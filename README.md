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

[![image](https://user-images.githubusercontent.com/518024/56973331-35e9d600-6b9f-11e9-8e41-b88185cfdea7.png)](https://youtu.be/WZl9TJuePsw)

# What is enable

> Credit is fundamentally broken when crossing borders - Cameron Stevens, Prodigy Finance

Enable is a peer-to-peer stablecoin credit marketplace, that allows:

- Borrowers to access global loans marketplace
- Lenders to access funding opportunities globally

This solves a pain point in emerging markets, where loans are difficult to get and often come at high interest rates. This is even though some borrowers have high credit rating and scores.

## Our 1st Customer

We are starting off with a concrete business use case - specifically, Ines' need to take a loan of \$60,000 to go to Cornell University in the US.

[Ines](https://www.linkedin.com/in/widya-imanesti) represents a reference customer that is stranded by structural inefficiences in traditional credit systems:

- She is the Head of HR of several notable startups and is going to a Cornell Masters that has expected graduation salaries of US\$80k+
- Her credit score in Indonesia does not follow her to the US and she is not able to take a loan there
- Indonesia's domestic interest rates are very high (i.e. 12-30%)
- Private and state-owned banks in Indonesia are still in the infancy and do not have large amount, long-tenor loans
- She is unable to utilize social attestation (e.g. references from husband, colleagues who have worked in the US) as part of her credit score to potentially lower her interest rate

**For Ines**, being able to access a global credit marketplace will allow her to:

- Fair interest rates (given risk)
- No need to lose 2.5% in forex exchange

**For lenders**, they are able to access a lending opportunity that has:

- 6% effective interest p.a. over 10 year tenor (i.e. 30%+ returns)
- Reputation-staked loan (Ines' public identity as well as social attestors)

### How we built enable

We utilized existing DeFi protocols, such as:

- [Bloom](https://bloom.co/) for identity attestation
- [OpenZeppelin's ERC20](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol) for crowdsale contract
- [Dharma's Loan Contracts](https://dharmaprotocol.github.io/developer-docs/#/) for debt token issuance

Learn more at our [wiki](https://github.com/onggunhao/enable/wiki/Architecture-&-Rationale)

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
