#!/bin/sh
rm -f lib/Angelos/Script/Gen/Flavor/App.pm
module-setup --pack Angelos::Script::Command::Gen::Flavor::App angelos > lib/Angelos/Script/Command/Gen/Flavor/App.pm
