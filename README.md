## Setting up OpenTelemetry Log Ingestion with RabbitMQ

### Pre-requisites
* Ensure that **Docker**, **Docker-Compose** and **git** are installed.
  Example on **AWS EC2**:

  ```
  # Install Docker and git
  sudo yum update -y 
  sudo amazon-linux-extras install docker 
  sudo yum install docker git -y
  sudo service docker start 
  sudo usermod -a -G docker ec2-user
  sudo docker info
  ```

  ```
  # Install Docker-Compose
  sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  docker-compose version
  ```
* Ensure that ports **5672** and **15672** on the host machine are exposed for external access.
* This setup uses a single VM. To deploy to multiple VMs, use Docker Swarm: <a href="https://docs.docker.com/engine/swarm/stack-deploy/" target="_blank">link</a>
---------------
### Start up a 3-node Rabbit instance
* Launch:
  ```
  git clone https://github.com/agapebondservant/workshop-rabbitgrpc.git
  cd workshop-rabbitgrpc
  rm -rf conf/data* conf/log*
  mkdir -p conf/data1 conf/data2 conf/data3 conf/log1 conf/log2 conf/log3
  sudo docker-compose up --remove-orphans -d
  ```

* Ensure that the cluster was started up correctly:
  ```
  sudo docker-compose logs -f
  ```

* Launch the Management Console (creds - guest/guest - you may change this by adding new environment variables **RABBITMQ_DEFAULT_USER** and **RABBITMQ_DEFAULT_PASS** to the docker-compose.yaml file):
  ```
  http://<host IP>:15672 (must ensure that port 15672 is exposed as an external port)
  ```

* To launch rabbitmqctl (example, view all enabled plugins):
  ```
  docker exec rabbit1 rabbitmq-plugins list -e
  ```
