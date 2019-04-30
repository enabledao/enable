# Enable
![Enable Logo](https://docs.google.com/uc?id=1G2QwMtnS4JcgCsN_OGaOQ8pt0D9sZ037)
<br/>
Stablecoin loans with borderless credit scoring through social attestation.

## Visit us

https://enable-loans.herokuapp.com/

## Contribute to development

We are building in public, in line with the open source ethos of  decentralized finance.

#### Deploying to Heroku:

As our repo is structured as a monorepo, the `/app` folder is the one that needs to be deployed to heroku.

##### Local machine

We need to tell git to push the  `/app` subtree to Heroku.
For more info: https://medium.com/@shalandy/deploy-git-subdirectory-to-heroku-ea05e95fce1f

```
git subtree push --prefix bloom-starter-react heroku master
```

##### Heroku Pipeline (CI / CD)

We currently use Heroku pipelines, and utilize `subdir-heroku-buildpack` to configure automatic deployments.
For more info: https://github.com/timanovsky/subdir-heroku-buildpack

**Step 1**:

**Step 2**: Add this to Heroku's config variables:
```
APP_BASE=app
```
