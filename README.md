transfers-scheduler
===================

This is an exercise app for iOS designed to schedule financial transfers.



Requirements
------------

1. The user can schedule a financial transfer with the following informations:
  - Origin account (pattern XXXXX-X)
  - Destination account (pattern XXXXX-X)
  - Transfer value
  - Tax (to be calculated)
  - Scheduled date
  - Type (A, B, C, D)
    * A: Type A operations have a tax of $2 plus 3% of the transfer value
    * B: Type B operations have a tax of $10 for orders scheduled within 30 days until the scheduled date and $8 for the others
    * C: Type C operations have a decreasing tax according to the scheduled date:
      - more than 30 days to the scheduled date - 1.2%
      - within 30 days to the scheduled date - 2.1%
      - within 25 days to the scheduled date - 4.3%
      - within 20 days to the scheduled date - 5.4%
      - within 15 days to the scheduled date - 6.7%
      - within 10 days to the scheduled date - 7.4%
      - within  5 days to the scheduled date - 8.3%
    * D: Type C operations have a tax equal to A, B or C depending of the transfer value:
      - Values until $25,000 follow the rules of operations type A 
      - Values from $25,001 until $120,000 follow the rules of operations type B
      - Values above $120,000 follow the rules of operations type C
2. The user are allowed to see all the scheduled transfers.

Note: A database is not required for data persistence.

