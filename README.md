# Enable

Enable is a “Kiva for Dai” that allows lenders to make peer-to-peer stablecoin microloans to emerging market borrowers. Our first product is a [peer-to-peer crowdloan kit](https://github.com/enabledao/enable/blob/master/product/specs/2019-07-14-v0.1-specs-(ines)/v0.1-specs.md).

We are an open source volunteer project that grew out of the [open finance hackathon](https://www.buildandship.it/) in May 2019. We are currently funded by a [3-month grant](https://twitter.com/onggunhao/status/1148140687327555584) from [Binance Labs](https://labs.binance.com/).

## See our progress

| Workstream                 | Github                                                    |
| -------------------------- | --------------------------------------------------------- |
| Enable Crowdloan Contracts | [repo](https://www.github.com/enabledao/enable-contracts) |
| Enable Crowdloan UI        | [repo](https://www.github.com/enabledao/enable-ui)        |
| Proof-of-concept fundraise | [Ines Fund](https://www.ines.fund)                        |

### Team

* Thomas Spofford, [@tspoff](https://github.com/tspoff) (USA)
* Anthony Adegbemi, [@adibas03](https://github.com/adibas03) (Nigeria)
* Daniel Onggunhao, [@onggunhao](https://github.com/onggunhao) (Singapore)
* Faisal Amir, [@urmauur](https://github.com/urmauur) (Indonesia)

## Roadmap

### Phase 1 (June - Aug 2019)
* [Single-loan peer-to-peer crowdloan kit](https://github.com/enabledao/enable/blob/master/product/specs/2019-07-14-v0.1-specs-(ines)/v0.1-specs.md)
* [Proof-of-concept fundraise](https://www.ines.fund): raising 60,000 Dai for Ines (Indonesia) to attend Cornell University

### Phase 2

* Open to ideas - debt tokens, collateralized loans, interest rate auctions

## Contributing

In line with the open source ethos of decentralized finance, we are committed to building in public. See the contributor instructions in the individual repos.

| Project                    | Contributor guide                                                 |
| -------------------------- | ----------------------------------------------------------------- |
| Enable Crowdloan Contracts | [instructions](https://www.github.com/enabledao/enable-contracts) |
| Enable Crowdloan UI        | [instructions](https://www.github.com/enabledao/enable-ui)        |

# About Enable

[![image](https://user-images.githubusercontent.com/518024/56973331-35e9d600-6b9f-11e9-8e41-b88185cfdea7.png)](https://youtu.be/Xqu4cmHzTis?t=3289)

> Credit is fundamentally broken when crossing borders - Cameron Stevens, Prodigy Finance

Enable is a peer-to-peer stablecoin credit marketplace, that allows:

- Borrowers to access global loans marketplace
- Lenders to access funding opportunities globally

This solves a pain point in emerging markets, where loans are difficult to get and often come at high interest rates. This is even though some borrowers have high credit rating and scores.

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
