# Running Wordpress locally, using docker

## What is Docker?
Docker is a tool designed to make it easier to create, deploy, and run applications by using containers. Containers allow a developer to package up an application with all of the parts it needs, such as libraries and other dependencies, and ship it all out as one package. [See here for more info](https://medium.com/@yannmjl/what-is-docker-in-simple-english-a24e8136b90b) 

## How is this relevant for me as a Wordpress novice?
It's far easier to learn Wordpress, and all the various plugins you might want to use, when you're doing it in a safe environment, and not on a deployed server you may have critical applications deployed on. Docker makes running wordpress on your local machine easy, in that you won't have to install all the various system level components and software in order to do all that. Just install Docker, and then follow the rest of this guide.

### Steps:

1. Download and install docker - https://www.docker.com/products/docker-desktop. Highly recommend reading [Why Docker?](https://www.docker.com/why-docker) to get a very basic understanding of what docker is, and how it works. In depth knowledge of Docker is not required for this, but it doesn't hurt to understand it a little, at a very basic level, either. 
2. Next, you're going to build the docker "images" required for running wordpress. In this case, we have three different services we want to run: wordpress (using apache), mysql db, and memcached. You can take a quick look at the docker-compose.yml file to see how these are specified. The Dockerfile is the definition for how we're going to build a customized wordpress Docker image. The other two services will automatically pull down the proper images from dockerhub. Run this command from your terminal shell, in the root of this project: `docker-compose up -d` This will do several things the first time you run it: 
    1. Builds the wordpress image
    2. Downloads the mysql and memcached images
    3. Launches each one of these services, using their respective images as running 'containers', in the background (that's the -d option to the command. without that, you'd be left in an interactive shell that printed out all the logs for each running container)
    4. Once that's done, you should be able to navigate to localhost in your browser, and see a brand new wordpress welcome screen, where you'll finish off the installation and setup. If you see the blog, then just go to localhost/wp-admin, and login using the default wordpress admin credentials for a new installation.
4. Configure away....
5. When you're done, you can either control-c out, if you're running interactively without the -d flag, or, type `docker-compose stop`, to stop all the services. You can also run `docker-compose down` to not only stop, but also remove the containers. Typically, you'll use stop. If you want to force a rebuild of the wordpress image, you can run `docker-compose build --no-cache`, which will completely rebuild the wordpress image.


## Contents of this repository, descriptions, etc
1. wordpress directory, which is a downloaded version of the latest wordpress. You simply update this to another version if you want, or, just upgrade from within the running application
2. Dockerfile - this is the file that instructs Docker how to build the Wordpress image. You shouldn't have to change anything in here, but you certainly can. If you look at the very first line, it indicates that this image will be based off (inherited from, basically), an image 'php:7.2-apache', meaning, it's a php image at version 7.2, and includes apache. php would be the image name, and 7.2-apache would be this particular builds tag. For the more curious, reference the docker documentation. 
3. docker-compose.yml - this file instructs docker how to run several different, cooperating services such that we have a complete working wordpress installation. Of note here are the port statements, like this from the db service block: "3308:3306" This is basically mapping the port on your computer, to the port that the service is running on in the container. So in the case of the db service, you could connect mysql workbench to localhost:3308, and you'd be able to directly interact with the mysql server running inside the db service container, which is based off of the official docker mysql image as "mysql:5.7". More importantly, the wordpress service has ports mapped as "80:80", so all you have to do in order to hit wordpress on your browser, is enter localhost as the url. The first port always refers to the port ON YOUR MACHINE, and the second port is the port that the service is running on inside the dockekr container. The final thing to be aware of, are the volume mappings. These allow us to inject files and directories that are ON YOUR MACHINE, into the file sytem of the running container. The three we're most concerned with are:
    1. - ./wordpress/:/var/www/html, in the wordpress service, which mounts the wordpress directory in the root of this project into the containers directory /var/www/html
    2. - ./wp-content/:/var/www/html/wp-content, also for the wordpress service, which over rides the wp-content directory, so that uploads, plugsin, etc, that you add within wordpress, will be available to you within this directory on your machine
    3. - wp-data:/var/lib/mysql, for the mysql/db service. This is so you don't lose your db data in between runs. The mysql data directory in the container will be mapped to this, and will persist between runs
4. uploads.ini - a php configuration that handles the upload file size limitation. This is used by the Dockerfile, during the image build process, and you can leave it alone. 

