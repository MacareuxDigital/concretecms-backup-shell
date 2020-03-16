<?php
namespace Application\Job;

use Concrete\Core\User\UserInfo;
use Core;
use Config;
use View;

class BatchModifyTestUsers extends \Concrete\Core\Job\QueueableJob
{
    /**
     * @return mixed
     */
    public function getJobName()
    {
        return t('Batch Modify Users');
    }

    /**
     * @return mixed
     */
    public function getJobDescription()
    {
        return t('An automated job to modify the existing user data.');
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
        switch ($environment) {
            case 'production':
            case 'live':
            case 'default':
                die;

        }

        // Get all users
        $list = new \Concrete\Core\User\UserList();

        /*
         *    Filter the users
         *        Comment out lines and apply the settings
        */
        // Exclude Administrators group users        
        $list->filterByGroup('Administrators', false);
        // Exclude users whose uID is less than 50 (exclude superadmin)
        // $list->filter('u.uID', 50,'>');
        // Exclude users who has never logged in.
        // $list->filter('u.uNumLogins', 1, '<');
        // Exclude users who is active
        // $list->filterByIsActive(false);
        // Exclude users who is validated
        // $list->filterByIsValidated(false);
        // Exclude users who was added at certain date
        // $list->filterByDateAdded($date, '<');
        // Exclude Administrators group users        
        // $list->filterByGroup('Administrators', false);
        // $list->filterByGroup('99999-Test', false);
        
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
                    $userName = '';
                    $data = [];
                    $userName = $oUser->getUserID();
                    // Add additional attribute changes
                    //$oUser->setAttribute('attribute', 'what-to-override');
                    $data = [
                        'uName' => $userName,
                        'uEmail' => $userName . '@example.com',
                    ];
                    $oUser->update($data);
                }
            } catch (\Exception $e) {
                $error->add($e);
            }

            //@TODO: Error handling
//            if ($error->has()) {
//                $this->set('error', $error);
//            }
        }
    }

}