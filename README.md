# AdMentor
AdMentor is a tool chain to evaluate the performance of ad networks. It is measure performance along the following dimensions: Memory, CPU, Network, System calls, and Energy. 
We evaluate the top 10 most popular ad networks using AdMentor. Our nethod and results are discussed in this paper[papre link will be add soon]

## Getting Started
Here you can find the source code for AdMentor tool. Most of our code was written using shell script and it requires Linux commands to run. AdMentor consists of three components. 
1- Loader.sh: which takes the app and performs the tests according to the required configuration. Then, it generates the
results. 
2- Extractor.sh: which extracts the generated results as csv file format that makes it easy to process the results. 
3- sys_trace.sh: Besides, a code must be inserted inside a rooted Android physical device. "sys trace" will be used by
the "Loader" to implement the tests using different metrics

### Prerequisites

To test the system calls, you need "strace". If you are testing in virtual environment, then it comes already packaged with SDK. If you are running it on actual phones, then you need to compile "strace", put it on phone, and call the executable. In this project, you can find the a compiled version of strace (not sure if it would work in your setting).

There are some other tools that this code use. 

*[Nexus Root Toolkit] http://www.wugfresh.com/nrt/

*[BusyBox] https://www.busybox.net/about.html

*[SuperSU] https://play.google.com/store/apps/details?id=eu.chainfire.supersu&hl=en

*[Trepn Profiler] https://developer.qualcomm.com/software/trepn-power-profiler

*[Trepn Profiler] https://play.google.com/store/apps/details?id=com.quicinc.trepn&hl=en

You can find the detailes in this paper[papre link will be add soon]

### Installing

Download the code, root the device, install the prerequest, and run the "Loader" from terminal.

## Running the tests

Extractor.sh, ExtractTenImplementation.sh, and Loader.sh are run from terminal. 

First you need to run Loader.sh using this format: ./Loader.sh TIME FileSuffex PhoneOutputDirectory > allout.txt 2>&1

For example:
```
#./Loader.sh 60 1 test1 > allout.txt 2>&1
```

Then you can extract data using:

```
#./Extractor.sh
```

sys_trace.sh run inside the Android device.

## Contributing
* **Bushra Aloraini** {baloraini@uwaterloo.ca} and  **Meiyappan Nagappan** {mei.nagappan@uwaterloo.ca}

## Authors

* **Sedeeq Al-khazraji** - *Initial work* -
https://github.com/SedeeqAlkhazraji

## License
This project is licensed under the  GNU GENERAL PUBLIC LICENSE License - see the [LICENSE.md](LICENSE.md) file for details

