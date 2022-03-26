
## Prerequisite

### Create .env file with the following values:
```
account=<docker account>
image=<docker image>
tag=<docker image tag>
email=<your email>
port=<ssh port>
```

## Commands

### Generate ssh key
    make ssh

### Build
	make build
    make build tag=v1.0

### Tag
	make tag
    make tag tag=v1.0

### Push docker image to remote repository
	make push

### Run docker 
    make run

### Get docker cointainer IP
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <cointainer id>

### SSH into a docker container
    ssh -i ssh/id_rsa root@0.0.0.0 -p 2200


### Example

    make build
    make run

    # in a separate tab
    ssh -i ssh/id_rsa root@0.0.0.0 -p 2200