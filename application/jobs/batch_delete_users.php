<?php
namespace Application\Job;

use Concrete\Core\User\UserInfo;
use Core;
use Config;
use View;

class BatchDeleteUsers extends \Concrete\Core\Job\QueueableJob
{
    /**
     * @return mixed
     */
    public function getJobName()
    {
        return t('Batch Delete Users');
    }

    /**
     * @return mixed
     */
    public function getJobDescription()
    {
        return t('An automated job to delete all users except super admin & the users in Administrators group.');
    }

    /**
     * @param \ZendQueue\Queue $q
     * @return mixed
     */
    public function start(\ZendQueue\Queue $q)
    {
        /*
         *    Production Safety Check
         *        Enable it if you want additional human error prevention.
         *
        */
        $request = \Concrete\Core\Http\Request::getInstance();
        $app = \Concrete\Core\Support\Facade\Application::getFacadeApplication();
        $environment = ($app->environment()) ? $app->environment() : 'default';
        if (
            ($environment == 'production') ||
            ($environment == 'default')
        ) {
            die;
        }

        // Get all users
        $list = new \Concrete\Core\User\UserList();

        /*
         *    Filter the users
         *        Comment out lines and apply the settings
        */
        // Exclude users whose uID is less than 1 (exclude superadmin)
        $list->filter('u.uID', 1,'>');
        // Exclude users who has never logged in.
        // $list->filter('u.uNumLogins', 1, '<');
        // Exclude users who is active
        // $list->filterByIsActive(false);
        // Exclude users who is validated
        // $list->filterByIsValidated(false);
        // Exclude users who was added at certain date
        // $list->filterByDateAdded($date, '<');
        // Exclude Administrators group users
        $list->filterByGroup('Administrators', false);
        // Include users who are in any of the $groups (array of \Concrete\Core\User\Group\Group instance)
        // $list->filterByInAnyGroup($groups, true)

        /*
         *    Sending user IDs to job queue to execute
         *
        */
        $results = $list->executeGetResults();
        foreach ($results as $queryRow) {
            $q->send($queryRow['uID']);
        }
    }

    /**
     * @param \ZendQueue\Queue $q
     * @return mixed
     */
    public function finish(\ZendQueue\Queue $q)
    {
        return t('All tasks processed');
    }

    /**
     * @param \ZendQueue\Message $msg
     * @return mixed
     */
    public function processQueueItem(\ZendQueue\Message $msg)
    {

        $error = Core::make('helper/validation/error');
        $vs = Core::make('helper/validation/strings');

        $ui = UserInfo::getByID($msg->body);
        $em = $ui->getUserEmail();
        if ($em) {
            try {

                if (!$vs->email($em)) {
                    throw new \Exception(t('Invalid user who\'s email address is ') . " | uid: " . $msg->body);
                }

                $oUser = UserInfo::getByEmail($em);
                if ($oUser) {
                    $oUser->triggerDelete($oUser);
                }
            } catch (\Exception $e) {
                $error->add($e);
            }
            if ($error->has()) {
                $this->set('error', $error);
            }
        }
    }

}