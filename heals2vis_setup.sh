#!/bin/bash

# Starting puppet (as Docker ENTRYPOINT from original Dockerfile does not run)
# NOTE: Second puppet apply is a fix for Jetty8 Puppet Bug (see Issue#37 on Whyis repository)
puppet apply /tmp/install_whyis.pp && puppet apply /tmp/install_whyis.pp

# NOTE: Inclusion of 'cd' in every command is to not break fil references when subshells are created in the bash script

# Dowloading application
cd /apps
git clone https://github.com/cancer-staging-ontology/cancer-staging-ontology.github.io

# Moving application
mv cancer-staging-ontology.github.io/heals2vis .
chown -R whyis:whyis heals2vis/

# Moving required application files
cp heals2vis/autonomic.py whyis/

# Chainging user to 'whyis', installing application
su - whyis -c "cd heals2vis && pip install -e ."

# Changing user to 'root', restarting apache2 and celeryd
service apache2 restart
service celeryd restart

# Loading data into the Whyis Blazegraph instance
su - whyis -c "cd /apps/whyis && python manage.py load -i /apps/heals2vis/data/viz.ttl -f turtle"
su - whyis -c "cd /apps/whyis && python manage.py load -i /apps/heals2vis/data/cancer_staging_terms.owl.ttl -f turtle"
su - whyis -c "cd /apps/whyis && python manage.py load -i /apps/heals2vis/data/civic-out.txt -f trig"
su - whyis -c "cd /apps/whyis && python manage.py load -i /apps/heals2vis/data/seer-out-sample.txt -f trig"

# Pre-running inferencer on the records
su - whyis -c "cd /apps/whyis && python manage.py test_agent -a heals2vis.inferencer.Infer"

# Creating dummy user for Demo
su - whyis -c "cd /apps/whyis && python manage.py createuser -e test@test.com -p test123 -f Test -l Testing -u test --roles=admin"

# Launching server
su - whyis -c "cd /apps/whyis && python manage.py runserver -h 0.0.0.0"
