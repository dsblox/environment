echo "Provisioning Server for" $1...
if [[ $1 == mss ]]; then
   echo "   Pulling dsblox/mss image from Docker Hub..."
   docker pull dsblox/mss
   echo "   Running dsblox/mss image as server daemon..."
   docker run --name mss -d -p 4000:4000 dsblox/mss
   echo "   Message Secure Send Server running on port 4000." 
else
   echo "   " $1 "is not a valid project.  Nothing to do."
fi
echo "...done."
