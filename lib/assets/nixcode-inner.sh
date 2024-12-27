#!PATH_TO_EXECUTOR

if [ ! -d PATH_TO_USER_DATA/User ]; then
  mkdir -p PATH_TO_USER_DATA/User
fi

if IS_SETTINGS_MUTABLE; then
  if [ ! -f PATH_TO_USER_DATA/User/settings.json ]; then
    cp PATH_TO_SETTINGS PATH_TO_USER_DATA/User/settings.json
  fi
else
  if [ -f PATH_TO_USER_DATA/User/settings.json ]; then
    rm -f PATH_TO_USER_DATA/User/settings.json
  fi
  ln -s PATH_TO_SETTINGS PATH_TO_USER_DATA/User/settings.json
fi

CODE_INSTANCE --user-data-dir=PATH_TO_USER_DATA $@