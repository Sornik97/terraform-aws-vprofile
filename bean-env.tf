resource "aws_elastic_beanstalk_environment" "vprofile-bean-prod" {
  name = "vprofile-bean-prod"
  application = aws_elastic_beanstalk_application.vprofile-prod
  solution_stack_name = "64bit Amazon Linux 2023 v5.1.2 running Tomcat 9 Corretto 11"
  cname_prefix = "vprofile-bean-prod-domain"
  setting {
    name = "VPCid"
    namespace = "aws:ec2:vpc"
    value = module.vpc.vpc_id
  }
  setting {
    name = "IamInstanceProfile"
    namespace = "aws:autoscaling:launchconfiguration"
    value = "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    name = "AssociatePublicIpAddress"
    namespace = "aws:ec2:vpc"
    value = "false"
  }

  setting {
    name = "Subnets"
    namespace = "aws:ec2:vpc"
    value = join(",", [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]])
  }
  setting {
    name = "ELBSubnets"
    namespace = "aws:ec2:vpc"
    value = join(",", [module.vpc.public_subnets[0], module.vpc.public_subnets[1], module.vpc.public_subnets[2]])
  }
  setting {
    name = "InstanceType"
    namespace = "aws:autoscaling:launchconfiguration"
    value = "t2.micro"
  }
  setting {
    name = "EC2KeyName"
    namespace = "aws:autoscaling:launchconfiguration"
    value = aws_key_pair.vprofilekey.key_name
  }
  setting {
    name = "Availability Zone"
    namespace = "aws:autoscaling:asg"
    value = "Any 3"
  }
  setting {
    name = "MinSize"
    namespace = "aws:autoscaling:asg"
    value = "1"
  }
  setting {
    name = "MaxSize"
    namespace = "aws:autoscaling:asg"
    value = "8"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "environment"
    value     = "prod"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "LOGGING_APPENDER"
    value     = "GRAYLOG"
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateEnabled"
    value     = "true"
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateType"
    value     = "Health"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MaxBatchSize"
    value     = "1"
  }
  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "CrossZone"
    value     = "true"
  }

  setting {
    name      = "StickinessEnabled"
    namespace = "aws:elasticbeanstalk:environment:process:default"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSizeType"
    value     = "Fixed"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSize"
    value     = "1"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = "Rolling"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.vprofile-prod-sg.id
  }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "SecurityGroups"
    value     = aws_security_group.vprofile_bean_elb_sg.id
  }

  depends_on = [aws_security_group.vprofile_bean_elb_sg, aws_security_group.vprofile-prod-sg]

}