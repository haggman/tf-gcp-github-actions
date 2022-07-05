# Terraforming GCP with GitHub Actions

This is a quick example using GitHub Actions to Terraform infrastructure in Google Cloud. Essentially, it does a Terraform plan when you do a pull request, and when the pull request is merged, it does the apply.

## Setup the Terraform state bucket:

1. Clone the repo onto your laptop.
2. Edit the *.tfvars* file and set the `project_id` and optionally, the `gcp_region` variables.
3. Initialize, plan, and apply the scripts. This will build a state bucket in your project. Note: You should consider adding an extra layer of encryption to your state file.

``` bash
terraform init
terraform plan
terraform apply
```

4. Copy the name of the new Terraform state bucket from the scripts output.
5. Edit the `main.tf` file. Uncomment the backend resource block and insert the name of your new tf state bucket.
6. Rerun init to copy the state file into the state bucket.

```bash
terraform init
```

7. Delete your local *.tfstate*

## Setup GitHub:

1. Create a new repo in GitHub and leave it empty for now. If you already have a repo you want to leverage, you will have to handle merging it with my steps, and the  contents of my repo.
1. Go over to GCP and create a Service Account. Give it sufficient permissions to create the resources it will be Terraforming. The Project Editor role works, but is probably more permissions than the SA truly requires.
1. Generate a key for the new SA. Open the file and copy the contents.
1. Switch to your new GitHub repo and create a new secret: **Settings | Secrets | Actions | New repository secret**. Name the secret `GCP_CREDENTIALS` and paste in the contents from the key file for the value.
1. Push the files to your new repo. Something like:

```bash
git remote add origin <path to your new repo>
git branch -M main
git push -u origin main
```

The repo should run the action, but since there's nothing to change, it won't actually do anything. Make sure to investigate the logs for the Action so you can ensure it ran successfully.

## Using the example:

Once you've run through the above steps, the workflow for Terraforming your project's infrastructure using the example would be easy.

- You edit your .tf files to create the infrastructure you need.
- If you want to do a Terraform plan, then execute a pull request in GitHub. The results of the plan will display directly in the pull request itself.
- When someone with merge ability merges the pull into the repo, a Terraform apply will be executed.
- If you push from your laptop directly, skipping the pull request, then it does the apply directly.