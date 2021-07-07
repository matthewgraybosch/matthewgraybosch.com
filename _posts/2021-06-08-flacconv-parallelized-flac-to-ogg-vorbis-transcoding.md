---
layout: post
title: ~/bin/flacconv
description: Parallelized FLAC to Ogg Vorbis transcoding on GNU/Linux and BSD
---

For some reason I had gotten it into my head to rip my entire CD collection to FLAC (Free Lossless Audio CODEC) so that I could have maximum fidelity digital music. After all, I had disk space out the wazoo and nothing better to do than swap CDs.

However, it's occurred to me that being a middle-aged metalhead I'm just wasting disk space. There might be a quantifiable difference between FLAC and Ogg Vorbis encoded at maximum quality, but it's not one I can hear with a decent set of wired headphones.

There's no sense in ripping everything again, though. Not when it's possible to transcode FLAC to Ogg Vorbis. However, I've got a *lot* of files and I don't want to spend weeks transcoding tracks piecemeal. Thus, I wrote a little script called "flacconv" that uses find and xargs to parallelize the process.

<details>
<summary>flacconv: parallelized FLAC to Ogg Vorbis conversion</summary>
<pre><code>#!/usr/bin/env bash

# © 2021 Matthew Graybosch <contact@matthewgraybosch.com>
# available under GPLv3

THREADS=${1}

find ${HOME} -name '*.flac' -print0 | xargs -0 -n ${THREADS} -P ${THREADS} oggenc -q 9
find ${HOME} -name '*.flac' -print0 | xargs -0 -n ${THREADS} -P ${THREADS} rm</code></pre></details>

You run this by calling "flacconv 8" (or however many cores your CPU has) and it will do the rest. Why do it this way? Because it's *fast*. It's so fast that [a well-crafted find/xargs sequence can outperform Hadoop for many workloads][1].

[1]: https://adamdrake.com/command-line-tools-can-be-235x-faster-than-your-hadoop-cluster.html "Adam Drake: Command-line Tools can be 235x Faster than your Hadoop Cluster"
