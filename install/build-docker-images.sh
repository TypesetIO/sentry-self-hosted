echo "${_group}Building and tagging Docker images ..."

echo ""
# Build any service that provides the image 083388942401.dkr.ecr.us-west-2.amazonaws.com/sentry-self-host first,
# as it is used as the base image for 083388942401.dkr.ecr.us-west-2.amazonaws.com/sentry-cleanup-self-hosted.
$dcb --force-rm web
# Build each other service individually to localize potential failures better.
for service in $($dc config --services); do
  $dcb --force-rm "$service"
done
echo ""
echo "Docker images built."

echo "${_endgroup}"
