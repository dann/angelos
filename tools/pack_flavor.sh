#!/bin/sh
rm -f lib/Angelos/Script/Gen/Flavor/App.pm
module-setup --pack Angelos::Script::Gen::Flavor::App angelos > lib/Angelos/Script/Gen/Flavor/App.pm
