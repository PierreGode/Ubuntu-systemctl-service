Why create cronjobs when you can run services?? <br />
If you have your cron setup with 10 different tasks, all the tasks will fail if cron fails. <br />
Cronjobs only work setting timers and reboot, while services can be configurated to start when for example network is up. 
also a service is running while cronjob can only be set to as low as once a minute.
<p></p>
@Created By Pierre Gode
