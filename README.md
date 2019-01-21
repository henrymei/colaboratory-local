# colaboratory-local
This repo allows for a convenient way to create a local notebook runtime. 
A secondary benefit is that Google Colaboratory can connect to it ([these steps](https://research.google.com/colaboratory/local-runtimes.html) are implemented). 
Chrome works best for Colaboratory but if you use Firefox, remember to set `network.websocket.allowInsecureFromHTTPS=true` in your browser settings. 


# Setup

If you are not familar with Docker/containerization and want some context, please read [this article](https://medium.freecodecamp.org/a-beginner-friendly-introduction-to-containers-vms-and-docker-79a9e3e119b). 

We need to make a place to store our Redshift credentials, so that we can connect to the warehouse within the notebook (after you run the following code, copy paste the password, and hit enter). This is better than having to either enter your credentials in every time you connect or storing your credentials in plaintext in the notebook. 
```
mkdir -p ~/.credentials
read -s password; echo $password > ~/.credentials/redshift_goodrx; unset password
chmod 700 ~/.credentials_temp
chmod 600 ~/.credentials_temp/redshift_goodrx
```

Go to the cloned repository folder in terminal, build the notebook server image, and start the server up:
```
docker-compose build 
docker-compose up -d
```

At this point, we should be able to access the notebook server by going to `http://localhost:8888/`. If you are trying to connect a Colaboratory notebook, make sure to select "Connect to a local runtime."

![Colaboratory connect to local](/readme/connect-to-local.gif)

Assuming the likely event that you need to run SQL against the data warehouse, make sure you tunnel locally. You're probably running a line of code like:
```
ssh -nNT -L15439:data-rs.internal.grxweb.com:5439 rs_tunnel@data-gw.internal.grxweb.com
```

If you are using Mac/PC, replace `localhost` in your connection string with `host.docker.internal`. If you're using Linux, you may have to adjust the `docker-compose.yml` and [hack your way around](https://github.com/qoomon/docker-host). 
The redshift credentials are mounted in `/run/secrets/redshift_password`, and that path is bound to `$REDSHIFT_PASSWORD_FILE` as a convenience.

An example of a typical in-notebook warehouse connection:
```
import os 
import sqlalchemy
from urllib.parse import unquote_plus

secret = os.environ['REDSHIFT_PASSWORD_FILE']
password = open(secret).read().rstrip('\n')
engine = sqlalchemy.create_engine('postgresql+psycopg2://hmei:%s@host.docker.internal:15439/main' % unquote_plus(password))
conn = engine.connect()
```
