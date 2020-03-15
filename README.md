# Example: a Basic Linux App Service

This example provisions a basic Linux App Service.

# Pre requisites:

--An azure subscription

--A resource group with SQL server (hardcoded servernames, resource group names etc should be changed per need)

--Another resource group with a keyvault

--A key named sqlsecret and value = the password used while creating SQL server


-#- see initial setup.txt for all commands to be run on Cloud shell to comeplete pre req

# Instructions

-- Open azure cloud shell - Choose bash. -first time configuration will ask for a storage acocunt to be created

-- Create  folder for cloning/ copying the files in this repo

-- clone/copy the files in this repo to the folder

-- create pre requisites (for the first time run) bu running the commands in the initial setup.txt

-- review terraform files and make sure that the rerource names used are correct. Also change the Tier of Db adn App Service as needed

-- run terraform init and plan to review the changes 

-- enter the location of the resources and name for the environment you are creating

-- review the resources created and copy the git clone url of the app service plan

-- push application code to this repository

-- Once finished run terraform destroy from same direcoty to destroy all resources

-- make sure that all resources are deleted and manually delete if anything left out to avoid any charges





