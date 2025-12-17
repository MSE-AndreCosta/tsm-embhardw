# tsm-embhardw

# Course Description

This module introduces the student to advanced concepts in modern embedded engineering.
The course concentrates on the architectures used in FPGA/SoC development and associated interfacing.
Exercises are practice-oriented and can be tested on a development board and are designed to ensure practical application of new knowledge.

# Learning objectives

The student will be able to design systems using state machines, soft-core processors, as well as interfacing peripherals to these automatons.
The student will be able to design and commission complete designs in an FPGA in an optimal manner, with optimal computation and optimal data transfers.
Exercises will be completed and applied on an FPGA development board with an Altera Cyclone IV device.

# DMA Results

Avec le DMA j'ai une moyenne de 23-24ms. Ceci est mesuré avec le timer de base, avec une granularité de 1ms.

Le tick de début est pris juste avant le début de l'écriture dans le LCD et le tick de fin est pris dans l'IRQ directement.

```c
/* Prise du tick de début */

...
start = timer_get_tick();
lcd_write_async(draw_buffer, LCD_WIDTH * LCD_HEIGHT * sizeof(*draw_buffer));
...

/* Prise du tick de fin */
static void lcd_dma_isr(void *context, alt_u32 id)
{
	is_transferring = false;
	isr_tick = timer_get_tick();
	lcd_ack_transfer();
}

/* Affichage du temps pris */
...
printf("Async Flush took %d\n", lcd_get_isr_tick() - start);
...
```

Output:

```
Async Flush took 23
Async Flush took 23
Async Flush took 23
Async Flush took 23
Async Flush took 23
Async Flush took 23
Async Flush took 23
Async Flush took 23
Async Flush took 23
Async Flush took 23
Async Flush took 23
Async Flush took 23
Async Flush took 23
```

Avec le CPU, j'ai une moyenne de 96ms. Ceci est mesuré avec le même timer.
Le tick de début est pris avant le démarrage de l'écriture et le tick de fin au retour de la fonction:

```c
uint32_t start = timer_get_tick();
lcd_write_direct(draw_buffer, LCD_WIDTH * LCD_HEIGHT * sizeof(*draw_buffer));
uint32_t end = timer_get_tick();

printf("Direct CPU write took %d\n", end - start);
```

Output:

```
Direct CPU write took 98
Direct CPU write took 96
Direct CPU write took 96
Direct CPU write took 96
Direct CPU write took 96
Direct CPU write took 96
Direct CPU write took 96
Direct CPU write took 96
Direct CPU write took 96
Direct CPU write took 96
```

# LVGL

Une fois capable d'afficher des choses sur le LCD, j'ai décidé de porter [LVGL](https://lvgl.io/) sur la plateforme
Pour cela, j'ai cloné le repertoire LVGL à côté de mon code source, lien: https://github.com/lvgl/lvgl et j'ai ajouté le répertoire source de mon project
comme un "Include Directory":

- Project -> Properties -> Nios II Application Properties -> Nios II Application Paths -> Application Include Directories -> Add

![](./media/nios_ii_app_path.png)

Une fois cela, j'ai du faire le portage de LVGL, le code source est disponible aussi:

![](./media/lvgl-nios-ii.png)


# Edge Detection

Each performance improvement step can be found in a logical manner in the commit history of [this repository](https://github.com/MSE-AndreCosta/tsm-embhardw)

## Starting point

**-O0**

| Function        | Time (ms) |
|-----------------|-----------|
| conv_grayscale  | 2407      |
| sobel_x         | 14483     |
| sobel_y         | 14569     |
| sobel_threshold | 2053      |

Total compute time = 33.512 seconds
Total Clock Cycles = 50MHz × 33.512s = 1,675,600,000 clock cycles
Pixel Count = 196,608
Clock Cycles/Pixel = 8,522 cycles/pixel

**-O1**

| Function        | Time (ms) |
|-----------------|-----------|
| conv_grayscale  | 744       |
| sobel_x         | 2526      |
| sobel_y         | 2525      |
| sobel_threshold | 659       |

Total compute time = 6.454 seconds
Total Clock Cycles = 50MHz × 6.454s = 322,700,000 clock cycles
Pixel Count = 196,608
Clock Cycles/Pixel = 1,641 cycles/pixel

**-O2**

| Function        | Time (ms) |
|-----------------|-----------|
| conv_grayscale  | 667       |
| sobel_x         | 2131      |
| sobel_y         | 2132      |
| sobel_threshold | 621       |

Total compute time = 5.551 seconds
Total Clock Cycles = 50MHz × 5.551s = 277,550,000 clock cycles
Pixel Count = 196,608
Clock Cycles/Pixel = 1,412 cycles/pixel

**-O3**

| Function        | Time (ms) |
|-----------------|-----------|
| conv_grayscale  | 722       |
| sobel_x         | 575       |
| sobel_y         | 528       |
| sobel_threshold | 621       |

Total compute time = 2.446 seconds
Total Clock Cycles = 50MHz × 2.446s = 122,300,000 clock cycles
Pixel Count = 196,608
Clock Cycles/Pixel = 622 cycles/pixel

## Loop Unrolling - Inner loop in `sobel_mac`

**-O0**

| Function        | Time (ms) |
|-----------------|-----------|
| conv_grayscale  | 2445      |
| sobel_x         | 10840     |
| sobel_y         | 10880     |
| sobel_threshold | 2062      |

Total compute time = 26.227 seconds
Total Clock Cycles = 50MHz × 26.227s = 1,311,350,000 clock cycles
Pixel Count = 196,608
Clock Cycles/Pixel = 6,670 cycles/pixel

## Loop Unrolling - Inner loop + Outer loop in `sobel_mac`

**-O0**

| Function        | Time (ms) |
|-----------------|-----------|
| conv_grayscale  | 2418      |
| sobel_x         | 8382      |
| sobel_y         | 8357      |
| sobel_threshold | 2041      |

Total compute time = 21.198 seconds
Total Clock Cycles = 50MHz × 21.198s = 1,059,900,000 clock cycles
Pixel Count = 196,608
Clock Cycles/Pixel = 5,390 cycles/pixel

## Inline `sobel_mac`

**-O0**

| Function        | Time (ms) |
|-----------------|-----------|
| conv_grayscale  | 2419      |
| sobel_x         | 8171      |
| sobel_y         | 8167      |
| sobel_threshold | 2045      |

Total compute time = 20.802 seconds
Total Clock Cycles = 50MHz × 20.802s = 1,040,100,000 clock cycles
Pixel Count = 196,608
Clock Cycles/Pixel = 5,291 cycles/pixel

## Merge `sobel_x` and `sobel_y` into a single function

**-O0**

| Function        | Time (ms) |
|-----------------|-----------|
| conv_grayscale  | 2419      |
| sobel_complete  | 16430     |
| sobel_threshold | 2045      |

Performance stays the same. Merging `sobel_x` and `sobel_y` together allows us to save a couple of clock cycles 
that are consumed when entering a function, these clock cycles are negligeable since these two functions are called only once.
Total compute time = 20.894 seconds
Total Clock Cycles = 50MHz × 20.894s = 1,044,700,000 clock cycles
Pixel Count = 196,608
Clock Cycles/Pixel = 5,314 cycles/pixel

## Interpolation

Here the approach was to skip calculating some pixels, in the sobel algorithm, I tried calculating every other pixel in a row,
meaning that I would calculate S(y,x) and I would copy the same value to S(y,x+1). This gave me a nice boost of performance but 
I would later revert the change when implementing the cache, as I realized that the result between this approach and the standard algorithm differentiated too much,
by the fact that sobel is meant to detect edges, and if the edge was thin enough, we would miss it.

**-O0**

| Function        | Time (ms) |
|-----------------|-----------|
| conv_grayscale  | 2419      |
| sobel_complete  | 8673      |
| sobel_threshold | 2045      |

Total compute time = 13.137 seconds
Total Clock Cycles = 50MHz × 13.137s = 656,850,000 clock cycles
Pixel Count = 196,608
Clock Cycles/Pixel = 3,341 cycles/pixel

## Grayscale approximation + reduce allocation count

Here, I implemented two performance optimizations.

First I removed the reallocation logic inside `conv_grayscale`. Before we would free the grayscale array every frame and reallocate,
this was modified to simply do the allocation if the size ever changed.

Secondly, the division by 100 was replaced with a right shift with 7.
This is to avoid the division with a more simpler operation that produces a similar result.

**-O0**

| Function        | Time (ms) |
|-----------------|-----------|
| conv_grayscale  | 1995      |
| sobel_complete  | 8660      |
| sobel_threshold | 2050      |

Total compute time = 12.705 seconds
Total Clock Cycles = 50MHz × 12.705s = 635,250,000 clock cycles
Pixel Count = 196,608
Clock Cycles/Pixel = 3,231 cycles/pixel

## Grayscale with green channel only


Here I implemented an algorithm change, in order to convert the grayscale value of the pixel, I decided to simply use the green channel, as the 
human eye is more sensible to the green channel. This avoids the bit shifts + masking to compute the other channels values, and also avoids the bit shift (division) previously done.

**-O0**

| Function        | Time (ms) |
|-----------------|-----------|
| conv_grayscale  | 1271      |
| sobel_complete  | 8660      |
| sobel_threshold | 2050      |

Total compute time = 11.981 seconds
Total Clock Cycles = 50MHz × 11.981s = 599,050,000 clock cycles
Pixel Count = 196,608
Clock Cycles/Pixel = 3,047 cycles/pixel

## Replace filter with hardcoded operations

Here I replaced the classical convolution and hardcoded the operations, since the mask is always the same, the operations were simplified as follows:

- Multiplication by 0 was removed, meaning that we don't account for the values in the middle column for the `x` result and we don't account for the values in the middle row for the `y` result.
- Multiplication by 1 was removed, we instead take the value of the pixel directly. Same with multiplication by `-1`, we simply negate the value
- Multiplication by 2 was kept with a bit shift

At the end, the compiler will have a much easier time optimizing our sobel result as it doesn't have to load the convolution mask from ram.

**-O0**

| Function        | Time (ms) |
|-----------------|-----------|
| conv_grayscale  | 1271      |
| sobel_complete  | 4029      |
| sobel_threshold | 2050      |


With these results, total compute time = 7.35 seconds

Total Clock Cycles = 50MHz * 7.35s = 367,500,000 clock cycles
Pixel Count = 196,608

Clock Cycles/Pixel = 1,869 cycles/pixel


## Compute threshold in sobel_complete

Here I realized that I could compute the `x`, `y` and the resulting `threshold` at the same time, which means I don't have to iterate the same image multiple times.

**-O0**

| Function        | Time (ms) |
|-----------------|-----------|
| conv_grayscale  | 1274      |
| sobel_complete  | 3751      |

With these results, total compute time = 5.025 seconds

Total Clock Cycles = 50MHz * 5.05s = 251,250,000 clock cycles
Pixel Count = 196,608

Clock Cycles/Pixel = 1278 cycles/pixel

**-O3**

| Function        | Time (ms) |
|-----------------|-----------|
| conv_grayscale  | 246       |
| sobel_complete  | 649       |

With these results, total compute time = 0.895 seconds

Total Clock Cycles = 50MHz * 0.895s = 44,750,000 clock cycles
Pixel Count = 196,608

Clock Cycles/Pixel = 228 cycles/pixel

At this point forward, we only care about the most optimal performance and thus, I stopped measuring the performance with `-O0`.

## Chunk-based with 16kB cache size

Here we decided to enable the cache, I used `4kB` Instruction Cache and a `16kB` Data Cache.

In our case, we have a very localized algorithm, we end up always doing the same instructions, as such our Instruction Cache doesn't have to be big.

As for the data cache, ideally, we would love to have the grayscale result in cache, the sobel result is not as important as the LCD will then have to fetch the data from RAM anyway,
so there's no reason to cache that result.

The grayscale size is of 512*384=196'608 Bytes. Unfortunately, the biggest cache size I could possibly enable is of 64kB, and even that doesn't fit in my Nios II.
I tried out 32 kB for the Data cache size but it seemed to hinder the performance. After trying 16kB, with a tile implementation that makes sense, I was able to improve the performance.

The tile approach, takes into account the cache size, and computes a "usable" cache size, which I arbitrarily decided to compute it as 70% of the total cache size.
With that we can calculate the amount of rows we can do per title, here we use rows as we want a contiguous memory so we don't jump around and invalidate the cache
Then for each chunk we convert and convolute that particular chunk until we've done the whole image.

**-O3**

| Function        | Time (ms) |
|-----------------|-----------|
| conv + sobel    | 350       |

With these results, total compute time = 0.350 seconds

Total Clock Cycles = 50MHz * 0.350s = 17,500,000 clock cycles
Pixel Count = 196,608

Clock Cycles/Pixel = 89 cycles/pixel


## Custom RGB to Grayscale function - 2 pixels

As for my first custom instruction, I decided to create a grayscale conversion function in VHDL, which will be super fast as we just need to connect the correct bits of the input signal
into the result signal.

The first implementation uses a single operand to take in 2 pixels (2x16bits = 1x32bits operand).

**-O3**

| Function        | Time (ms) |
|-----------------|-----------|
| conv + sobel    | 270       |

With these results, total compute time = 0.270 seconds

Total Clock Cycles = 50MHz * 0.270s = 13,500,000 clock cycles
Pixel Count = 196,608

Clock Cycles/Pixel = 68 cycles/pixel

## Custom RGB to Grayscale function - 4 pixels

After seeing how fast it was, I went ahead and implemented a version that takes in 2 operands, meaning that we can do 4 pixels in a single operation.
This improved the performance further.

**-O3**

| Function        | Time (ms) |
|-----------------|-----------|
| conv + sobel    | 240       |

With these results, total compute time = 0.240 seconds

Total Clock Cycles = 50MHz * 0.240s = 12,000,000 clock cycles
Pixel Count = 196,608

Clock Cycles/Pixel = 61 cycles/pixel

## Replace width/height variables with constant values

As we finalize the implementation, I decided to replace the variable width and height variables with constant values,
this allows the compiler to optimize the loops as the iteration count is now known at compile time.
Using variables means that the compiler can't optimize the loops as it doesn't know the width and height at compile time, we do though and replacing the width and height with constant values
actually produces performance gains

Another important remark here is that we need to also use these constants inside the grayscale and sobel functions, if we simply replace the invocations of 
these functions with these constant values, the compiler won't be able to optimize them, even if we invoke these functions with the same parameters all the time.
This is because compiler optimizations are done at the translation unit level. Optimizations across multiple translation units, require Link-time Optimizations to be enabled.

**-O3**

| Function        | Time (ms) |
|-----------------|-----------|
| conv + sobel    | 224       |

With these results, total compute time = 0.224 seconds

Total Clock Cycles = 50MHz * 0.224s = 11,200,000 clock cycles
Pixel Count = 196,608

Clock Cycles/Pixel = 56 cycles/pixel


## Only convert and use sobel filter on the required pixels (240x320)

Finally, for the final optimization, I stopped converting and computing the sobel over the whole image that comes from the camera, instead
when converting the image to grayscale, we simply compute the top left part of it, matching the LCD dimensions.

Here's an image showing what part I grab from the camera image. This allows me to save a lot of cycles that we previously used to compute cycles that would be
dropped and never shown anyway.

![](./media/lcd-camera-dimensions.png)

**-O3**

| Function        | Time (ms) |
|-----------------|-----------|
| conv + sobel    | 90        |

With these results, total compute time = 0.09 seconds -- 11.1 FPS

Total Clock Cycles = 50MHz * 0.09s = 4,500,000 clock cycles
Pixel Count = 196,608

Clock Cycles/Pixel = 22 cycles/pixel
