# ETLC_ApexBridge

## Synopsis

**Design pattern for communication between Lightning Components and Apex.**

This repository contains the library that implements the ApexBridge design pattern, a simpler way to build Lightning Components that interact with Apex server-side controllers.

## Update (March 2018)
This is a rewrite of the original library I created back in July, 2016. A lot of improvements have been made to the Lightning Components Framework like Lightning Data Services (force:recordData) and lightning:recordEditForm, and although they are great to work with a single record, and they respect user security, they can not work with multiple records, or make other things in the platform like sending emails, making webservice calls from the server or anything else where Apex is required. So this library is still relevant, for those use cases.

I have also moved the code to Salesforce DX so you can install the library and the samples by using two different packages.

## Motivation

Lightning Components is a pretty cool technology that allows you to write SPA architecture applications where most logic happens on the client, but you still need to talk to the back end for other operations like reading and writing data to your custom and standard objects, sending emails, talking to external web servers, etc. Although communicating with a server is important task, there is not a clean reusable way of handling this communication.

Why did I build it? read this [blog article](http://eltoro.it/ETLC_ApexBridge) to understand what motivated me to create this?

## How Does It Work?

To learn how the ApexBridge design pattern works, and how to implement the ETLC_ApexBridge library in your projects, please [watch this presentation](./ETLC_ApexBridge_UnderstandingTheDesignPattern.pps). For further details please check the [developer guide](./ETLC_ApexBridge_DeveloperGuide.pdf).

There are also a companion package that can be installed to view the demos.

## Installation

Using Salesforce DX CLI you can install the packages like this:

| What | SFDX CLI Command | URL |
| --- | --- | --- | 
| Library | sfdx force:package:install -i 04t6A000002D2ElQAK | https://test.salesforce.com/packagingSetupUI/ipLanding.app?apvId=04t6A000002D2ElQAK |
| Demos | sfdx force:package:install -i 04t6A000002D2EqQAK | https://test.salesforce.com/packagingSetupUI/ipLanding.app?apvId=04t6A000002D2EqQAK |

## History

| Version | Description |
| --- | --- |
| 3.0 | Library rewrite using Salesforce DX |
| 2.0 | Simplified the implementation of the library, added documentation |
| 1.0 | First code release |

## License

This repository uses the MIT library, which basically means it’s free… Enjoy!

## About Me

ElToroIT [Twitter](https://twitter.com/ElToroIT) [LinkedIn](https://www.linkedin.com/in/eltoroit) loves helping developers understand Salesforce and how easy is to work with this great platform. He also teaches the Salesforce [developer courses](http://www.salesforce.com/services-training/training_certification/training-by-role.jsp) in English and Spanish.


Don't forget to visit my blog: [http://eltoro.it](http://eltoro.it) 
