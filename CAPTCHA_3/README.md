# Animated Character Drawing and Recognition - Shan Teng

## Introduction
This CAPTCHA game consists of two parts: drawing and recognition. The user is first required to draw a randomly generated character on the OLED screen by making connections between certain nodes. The user then has to recognize three randomly generated characters drawn by the system, which are formed by animated lines going through the nodes. The user has to memorise the characters and input them on the OLED in the correct order. 

### User Behavious Analysis
To differentiate a human user from a bot, we will consider the following factors:
- **Order of connection**: A human user will connect the nodes in an order similar to how he/she would write the character. A bot will connect the nodes in a random order.
- **Time taken to connect**: A human user will take a longer time to connect the nodes and input the characters compared to a bot.