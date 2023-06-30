```bash
### Set Script Variables
DOMAIN=domain.url
CarbideRegistry=registry.url
CarbideLicense=license

### Run the Carbide Script
curl -#OL https://raw.githubusercontent.com/zackbradys/rgs-carbide/main/shell/carbide-apps.sh | sed -e 's/$DOMAIN/'$DOMAIN'/g' -e 's/$CarbideRegistry/'$CarbideRegistry'/g' -e 's/$CarbideLicense/'$CarbideLicense'/g' | bash
```