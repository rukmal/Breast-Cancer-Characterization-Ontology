# Dowloading application
cd /apps
git clone https://github.com/cancer-staging-ontology/cancer-staging-ontology.github.io

# Moving application
mv cancer-staging-ontology.github.io/heals2vis .
chown -R whyis:whyis heals2vis/

# Moving required application files
cp heals2vis/autonomic.py whyis/

# Chainging user to 'whyis', installing application
cd heals2vis
sudo -u whyis pip install -e .

# Changing user to 'root', restarting apache2 and celeryd
service apache2 restart
service celeryd restart

# Changing user to 'whyis', moving to application directory
cd /apps/whyis

# Loading data into the Whyis Blazegraph instance
sudo -u whyis python manage.py load -i /apps/heals2vis/data/viz.ttl -f turtle
sudo -u whyis python manage.py load -i /apps/heals2vis/data/cancer_staging_terms.owl.ttl -f turtle
sudo -u whyis python manage.py load -i /apps/heals2vis/data/civic-out.txt -f trig
sudo -u whyis python manage.py load -i /apps/heals2vis/data/seer-out-sample.txt -f trig

# Pre-running inferencer on the records
sudo -u whyis python manage.py test_agent -a heals2vis.inferencer.Infer

# Creating dummy user for Demo
sudo -u whyis python manage.py createuser -e test@test.com -p test123 -f Test -l Testing -u test --roles=admin

# Launching server
sudo -u whyis python manage.py runserver -h 0.0.0.0
