# Restore Strategy

The backup file include the webgis-config.json file.

The webgis-config.json file include the information about the webgis system.

The formatted sample after webgisdr run at blue env:
```json
{
    "portals": [
        {
            "baseBackupTimeStamp": 0,
            "publicPortalURL": "https://PORTALWEBCONTEXTURL",
            "blobUrl": "",
            "providerType": "FileSystem",
            "mode": "BACKUP",
            "primaryMachineURL": "https://PORTALBLUEINTERNALFQDN:7443/arcgis",
            "password": "ENCRYPTEDPASSWORD",
            "servers": [
                {
                    "mode": "BACKUP",
                    "dataStores": [
                        {
                            "mode": "BACKUP",
                            "baseBackupTimeStamp": 0,
                            "storeTypes": [
                                "tileCache"
                            ],
                            "role": "PRIMARY",
                            "backupLoc": "\\dataStore\\8b71a221-e5cc-4859-ae90-7b133aa2204b",
                            "serverURL": "https://SERVERWEBCONTEXTURL/arcgis/admin",
                            "id": "8b71a221-e5cc-4859-ae90-7b133aa2204b",
                            "adminURL": "https://DATASTOREINTERNALFQDN:2443/arcgis/datastoreadmin",
                            "ancestors": [],
                            "backupName": "20220823-140858-UTC-63-BACKUP"
                        },
                        {
                            "mode": "BACKUP",
                            "baseBackupTimeStamp": 0,
                            "storeTypes": [
                                "relational"
                            ],
                            "role": "PRIMARY",
                            "backupLoc": "\\dataStore\\98c7a14d-afc9-498a-b2ba-d3274567d7c6",
                            "serverURL": "https://SERVERWEBCONTEXTURL/admin",
                            "id": "98c7a14d-afc9-498a-b2ba-d3274567d7c6",
                            "adminURL": "https://DATASTOREINTERNALFQDN:2443/arcgis/datastoreadmin",
                            "ancestors": [],
                            "backupName": "20220823-140845-UTC-95-BACKUP"
                        }
                    ],
                    "baseBackupTimeStamp": 1661264734125,
                    "isHosted": true,
                    "serverURL": "https://WEBCONTEXTURL/arcgis/admin",
                    "location": "\\server\\2sdsalpx0gdxzjcs\\20220823-140812-UTC.agssite",
                    "id": "2sDsaLPX0gDXZJCs",
                    "adminURL": "https://IP:6443/arcgis/admin",
                    "validatedServerUrl": "https://SERVERWEBCONTEXTURL/admin",
                    "version": "10.9.1"
                }
            ],
            "privatePortalURL": "",
            "location": "\\portal\\20220823-140805-UTC-BACKUP.portalsite",
            "expiration": 60,
            "adminURL": "https://PORTALBLUEINTERNALFQDN:7443/arcgis/portaladmin",
            "username": "PORTALUSER"
        }
    ],
    "backupTimeStamp": 1661265084926,
    "backupName": "20220823-140892-UTC-BACKUP",
    "version": "10.9.1"
}
```

When restoring to "Green" environment, please modify the blue internal fqdn to the green internal fqdn.

After that, run the webgisdr utility:

```
webgisdr.bat -i -f WEBGISDRPROPERTYFILEPATH
```