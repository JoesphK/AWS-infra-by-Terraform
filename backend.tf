#======================================AWS CONFIG=======================

#terraform {
  #backend "s3" {
    #bucket         = "youssefterraformbucket" #My bucket
    #key            = "terraform.tfstate"      #Key name
    #region         = "us-east-1"              #Region
    #use_lockfile  = true              #Encrypt
  #}
#}
#===============================AZURE
terraform {
  backend "azurerm" {
    resource_group_name  = "JoeTerraformTrainer"      # Replace with your Azure Resource Group name
    storage_account_name = "joesterraformstorage"  # Replace with your Azure Storage Account name (globally unique, lowercase)
    container_name       = "tfstate"              # Replace with your Azure Storage Container name
    key                  = "terraform.tfstate"    # The name of your state file within the container
  }
}