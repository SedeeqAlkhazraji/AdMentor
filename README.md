# AdMentor
AdMentor is a tool chain to evaluate the performance of ad networks. It is measure performance along the following dimensions: Memory, CPU, Network, System calls, and Energy. 
We evaluate the top 10 most popular ad networks using AdMentor. Our nethod and results are discussed in this paper[papre link will be add soon]

Here you can find the source code for AdMentor tool. AdMentor consists of three components. 
1- Loader: which takes the app and performs the tests according to the required configuration. Then, it generates the
results. 
2- Extractor: which extracts the generated results as csv file format that makes it easy to process the results. 
3- sys trace: Besides, a code must be inserted inside a rooted Android physical device. "sys trace" will be used by
the "Loader" to implement the tests using different metrics
