  echo "Processing deploy.sh"
  # Set EB BUCKET as env variable
  EB_BUCKET=<eb-bucket>
  aws configure set default.region <aws-region>
  eval $(aws ecr get-login --no-include-email --region <aws-region>)
  docker --version
  # Build docker image based on dockerfile-prod
  # NO SPACES between scopes e.g. scopes-1,scopes-2,scopes-3
  docker build -t <dockerhub-org-name>/<app-name> -f Dockerfile-prod --build-arg DATABASE_MIGRATIONS=0 --build-arg DATABASE_SCOPES= .
  # Push built image to ECS
  docker tag <dockerhub-org-name>/<app-name>:latest <aws-ecr>.dkr.ecr.<aws-region>.amazonaws.com/<app-name>:$TRAVIS_COMMIT
  docker push <aws-ecr>.dkr.ecr.<aws-region>.amazonaws.com/<app-name>:$TRAVIS_COMMIT
  # Replace the <VERSION> in Dockerrun file with travis SHA
  sed -i='' "s/<VERSION>/$TRAVIS_COMMIT/" Dockerrun.aws.json
  # Zip modified Dockerrun with any ebextensions
  zip -r <app-name>-prod-deploy.zip Dockerrun.aws.json .ebextensions
  # Upload zip file to s3 bucket
  aws s3 cp <app-name>-prod-deploy.zip s3://$EB_BUCKET/<app-name>-prod-deploy.zip
  # Create a new application version with new Dockerrun
  aws elasticbeanstalk create-application-version --application-name <aws-app-name> --version-label $TRAVIS_COMMIT --source-bundle S3Bucket=$EB_BUCKET,S3Key=<app-name>-prod-deploy.zip
  # Update environment to use new version number
  aws elasticbeanstalk update-environment --environment-name <app-name>-prod --version-label $TRAVIS_COMMIT