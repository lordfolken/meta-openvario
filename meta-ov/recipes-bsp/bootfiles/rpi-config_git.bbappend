# Appends the config.txt used in the Rapsberry PI boot process to adapt Openvario
# relevant changes

do_deploy:append () {

	CONFIG=${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt

     # Openvario 57 LVDS
    if [ "${MACHINE}" = "ov-rpi4-64" ]; then
        # Use the machine specific device tree overlay
        echo "# Enable 57 LVDS" >> $CONFIG
        echo "dtoverlay=ov-rpi4-57-lvds" >> $CONFIG
        
        # Enable OTG mode
        echo "otg_mode=1" >> $CONFIG
    fi

     # Openvario 7 PQ070
    if [ "${MACHINE}" = "ov-cm4-7-pq070" ]; then
        # Use the machine specific device tree overlay
        echo "# Enable PQ070 Display" >> $CONFIG
        echo "dtoverlay=ov-cm4-7-pq070" >> $CONFIG

        # Enable OTG mode
        echo "otg_mode=1" >> $CONFIG
    fi
}