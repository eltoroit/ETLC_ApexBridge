# ETLC_ApexBridge

## Synopsis

**Design pattern for communication between Lightning Components and Apex.**

This repository contains the library that implements the ApexBridge design pattern, a simpler way to build Lightning Components that interact with Apex server-side controllers.


## Motivation

Lightning Components is a pretty cool technology that allows you to write SPA architecture applications where most logic happens on the client, but you still need to talk to the back end for other operations like reading and writing data to your custom and standard objects, sending emails, talking to external web servers, etc. Although communicating with a server is important task, there is not a clean reusable way of handling this communication.

## Installation

<a href="https://githubsfdeploy.herokuapp.com?owner=ElToroIT&repo=ETLC_ApexBridge">
  <img alt="Deploy to Salesforce" src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

#### How Does It Work?

To understand how the ApexBridge design pattern works, and how to implement the ETLC_ApexBridge library in your projects, please [watch this presentation](./ETLC_ApexBridge_UnderstandingTheDesignPattern.pps). For further details please check the [developer guide](./ETLC_ApexBridge_DeveloperGuide.pdf).

There are also some companion sample files in [https://github.com/eltoroit/ETLC_SecureDB_Samples](this repository).

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## History

| Version | Description |
| --- | --- |
| 2.0 | Simplified the implementation of the library, added documentation |
| 1.0 | First code release |

## License

This repository uses the MIT library, which basically means it’s free… Enjoy!

## About Me

ElToroIT [Twitter](https://twitter.com/ElToroIT) [LinkedIn](https://www.linkedin.com/in/eltoroit) loves helping developers understand Salesforce and how easy is to work with this great platform. He also teaches the Salesforce [developer courses](http://www.salesforce.com/services-training/training_certification/training-by-role.jsp) in English and Spanish.


Don't forget to visit my blog: [http://eltoro.it](http://eltoro.it) 
