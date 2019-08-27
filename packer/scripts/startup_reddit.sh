#!/bin/bash

cp /tmp/reddit.service /etc/systemd/system/reddit.service
chmod 664 /etc/systemd/system/reddit.service
systemctl daemon-reload
systemctl enable reddit
systemctl start reddit
