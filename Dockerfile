FROM ubuntu:bionic

WORKDIR /usr/badgr

# Install Ubuntu dependencies
RUN apt-get update

RUN apt-get -y install git python python-virtualenv libcairo2 xmlsec1 nodejs npm curl

RUN apt-get -y install git-core gcc python-pip python-dev swig libxslt-dev automake autoconf libtool libffi-dev default-libmysqlclient-dev

# Clone Badgr Server
RUN git clone https://github.com/concentricsky/badgr-server.git .

# Install Python dependencies
RUN pip install -r requirements.txt

# Load default settings
RUN cp apps/mainsite/settings_local.py.example apps/mainsite/settings_local.py

# Allow anyone to connect to Badgr /!\ WARNING: BE CAREFUL IN PRODUCTION ENVIRONMENTS /!\
RUN echo "ALLOWED_HOSTS = ['*']\n" >> apps/mainsite/settings_local.py

# Migrate the database
RUN python ./manage.py migrate

# Generate API docs
RUN python ./manage.py dist

# Generate admin account automatically
RUN python ./manage.py shell -c "from badgeuser.models import BadgeUser as User; User.objects.create_superuser('admin', 'admin@example.com', 'admin1234')"

# Expose the running port
EXPOSE 8000

# Run Badgr server
CMD ["python", "./manage.py", "runserver", "0.0.0.0:8000"]