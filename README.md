# Enable

Stablecoin loans with borderless credit scoring through social attestation.

## Visit us

https://enable-loans.herokuapp.com/

## Contribute to development

We are building in public, in line with the open source ethos of  decentralized finance.

#### Deploying to Heroku:

We need to tell git to push the  `/app` subtree to Heroku, otherwise Heroku will throw an error.

Source: https://medium.com/@shalandy/deploy-git-subdirectory-to-heroku-ea05e95fce1f

```
git subtree push --prefix bloom-starter-react heroku master
```

We currently use Heroku pipelines, and utilize `heroku-buildpack-monorepo` to configure automatic deployments.

In Heroku's config variables:
```
APP_BASE=app
```
