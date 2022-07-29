App Configuration
======================

Files in this folder are used to specify configuration options that Backstage will use when deploying and managing your app.

These files include:
- **notifications.json** : e-mail and Slack notification subscriptions for your app (changes are handled by *NotificationHub*).
- **deploy.json** : specifies properties of the stack that is deployed for your app, including load balancer and autoscaling options, SSL certificates, and base AMI, among others.
- **cloudformation** :
  - template/cloudformation.yml : customized cloudformation template that Aerosol service will execute
  - config/config.json : configurations for your cloudformation template (providing cft parameters and tags)
  - Aerosol documentation: https://confluence.expedia.biz/display/AK/Aerosol

**Configuration File Validation**
- When changes are made to files in this folder, a pre-receive hook on your repo will perform a shallow validation on these files before allowing the commit.

**Configuration File Parsing**
- When a commit changes one or more of the files in this folder, a service called OCPCM (*Our Cloud Platform Configuration Manager*) will send the changed file(s) to the appropriate endpoints for validation, parsing, and processing.

**Documentation**
- https://confluence.expedia.biz/display/KUMO/Configuration+Validator

**For more information**
- Post questions in the [#eg-backstage](https://expedia.slack.com/archives/C014JN1TVT6) Slack channel.

