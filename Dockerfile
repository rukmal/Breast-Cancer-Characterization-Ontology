FROM tetherlessworld/whyis:release

COPY heals2vis_setup.sh /heals2vis_setup.sh

RUN chmod a+x heals2vis_setup.sh
