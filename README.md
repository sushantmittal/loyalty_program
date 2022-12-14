# Loyalty program practical example

## About

At it's most basic, the platform offers clients the ability to issue loyalty points to their end users.
End users use their points to claim/purchase rewards offered by the client.

## Point Earning Rules

**Level 1**

1. For every $100 the end user spends they receive 10 points

**Level 2**

1. If the end user spends any amount of money in a foreign country they receive 2x the standard points

## Issuing Rewards Rules

**Level 1**

1. If the end user accumulates 100 points in one calendar month they are given a Free Coffee reward

**Level 2**

1. A Free Coffee reward is given to all users during their birthday month
2. A 5% Cash Rebate reward is given to all users who have 10 or more transactions that have an amount > $100
3. A Free Movie Tickets reward is given to new users when their spending is > $1000 within 60 days of their first transaction

## Loyalty Rules

**Level 1**

1. A standard tier customer is an end user who accumulates 0 points
2. A gold tier customer is an end user who accumulates 1000 points
3. A platinum tier customer is an end user who accumulates 5000 points

**Level 2**

1. Points expire every year
2. Loyalty tiers are calculated on the highest points in the last 2 cycles
2. Give 4x Airport Lounge Access Reward when a user becomes a gold tier customer
3. Every calendar quarterly give 100 bonus points for any user spending greater than $2000 in that quarter


### Requirements

- Install Ruby version: 3.0.2.
- Install `postgresql` and `redis` and start them.

## Local Development Setup

```
bin/setup
```

## Testing
```
rails test
```
