# Enable

Stablecoin loans with borderless credit scoring through social attestation.

Enable is a hackathon project that started during the [Ethereal + Consensys Labs Open Finance Hackathon](https://www.buildandship.it/).

The team comprises of Thomas Spofford (USA), Anthony (Nigeria), Widya Imanesti (Indonesia) and Daniel Ong (Singapore).

## See our progress

We are currently building in public:

**Staging**: [https://enable-loans-staging.herokuapp.com/](https://enable-loans-staging.herokuapp.com/)

**Production**: [https://enable-loans.herokuapp.com/](https://enable-loans.herokuapp.com/)

**Backlog**: [Github Project Board](https://github.com/onggunhao/enable/projects/1)

## Video Introduction

![image](https://user-images.githubusercontent.com/518024/56973331-35e9d600-6b9f-11e9-8e41-b88185cfdea7.png)

# What is enable

Credit is fundamentally

# How to participate

We are building in public - in line with the open source ethos of decentralized finance. Most of our discussions are tracked in Github issues, including business-related ones.

#### Deploying to Heroku:

As our repo is structured as a monorepo, the `/app` folder is the one that needs to be deployed to heroku.

##### Local machine

We need to tell git to push the `/app` subtree to Heroku.
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
