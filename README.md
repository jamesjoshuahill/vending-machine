# Vending machine

This code test was set by a London tech company. Time allowed: 24 hours.

## The challenge

Design a vending machine in code. The vending machine should perform as follows:
  
  - Once an item is selected and the appropriate amount of money is inserted, the vending machine should return the correct product.
  - It should also return change if too much money is provided, or ask for more money if insufficient funds have been inserted.
  - The machine should take an initial load of products and change. The change will be of denominations 1p, 2p, 5p, 10p, 20p, 50p, £1, £2.
  - There should be a way of reloading either products or change at a later point.
  - The machine should keep track of the products and change that it contains.

Please develop the machine in ruby.

## My response

I wrote a an object oriented model of a vending machine in Ruby using RSpec and Guard for TDD. With a tight deadline
there is room for improvement and development of the behaviour. In particular:

  - The responsibility for displaying messages to the customer should be extracted into a separate object.
  - Support for issuing change when more than one coin is required.
  - The product shelf and coin hopper could be extended to provide a detailed inventory.
  - Extend the vending machine with a cancel action to return the coins inserted.
  - Combine the coins inserted and coins collected so that change can be issued using any of the coins in the vending machine.
  - Refactor the vending machine spec into acceptance tests and unit tests for
  vending machine and its collaborators.
