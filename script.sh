#!/bin/bash
wget https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.12.13+hotfix.5-stable.tar.xz
tar xvf ~/flutter_linux_v1.12.13+hotfix.5-stable.tar.xz
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor
