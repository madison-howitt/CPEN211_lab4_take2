//shared file for lab 4
.globl binary_search
binary_search:

int numbers[100] = {
28, 37, 44, 60, 85, 99, 121, 127, 129, 138,
143, 155, 162, 164, 175, 179, 205, 212, 217, 231,
235, 238, 242, 248, 250, 258, 283, 286, 305, 311,
316, 322, 326, 351, 355, 364, 366, 376, 391, 398,
408, 410, 415, 418, 425, 437, 441, 452, 474, 488,
506, 507, 526, 532, 534, 547, 548, 583, 585, 595,
603, 621, 640, 661, 666, 690, 692, 713, 719, 750,
755, 768, 775, 776, 784, 785, 791, 797, 798, 804,
828, 842, 846, 858, 884, 887, 890, 893, 908, 936,
939, 953, 960, 970, 978, 979, 981, 990, 1002, 1007 };
int main(void)
{
volatile int *ledr = (int*) 0xFF200000; // recall LEDR_BASE is 0xFF200000
int index = binary_search(numbers,418,100);
*ledr = index; // display the *final* index value on the red LEDs as in Lab 8
}
    MOV R3, #0             // startIndex = 0
    SUB R4, R2, #1         // endIndex = length - 1
    MOV R5, R4, ASR #1     // middleIndex = endIndex / 2
    MOV R6, #-1            // keyIndex = -1 (is output when the key is not found)
    MOV R7, #1             // NumIters = 1

binary_search_loop:
    CMP R6, #-1
    BNE end_search          // if keyIndex != -1, break
    CMP R3, R4             // First we compare startIndex and endIndex
    BGT end_search         // If startIndex > endIndex, exit the loop

    // Loading numbers[middleIndex] into R8
    LDR R8, [R0, R5, LSL #2] // R8 = numbers[middleIndex]

    CMP R8, R1             // Compare numbers[middleIndex] with key
    BEQ found_key          // If equal, set keyIndex to be that location and exit loop

    CMP R8, R1             // Check if numbers[middleIndex] > key
    BGT adjust_endIndex    // If greater, adjust the endIndex

    // Adjust the startIndex = middleIndex + 1
    ADD R3, R5, #1
    B update_middleIndex

adjust_endIndex:
    // Adjust the endIndex = middleIndex - 1
    SUB R4, R5, #1

update_middleIndex:
    // Update numbers[middleIndex] to -NumIters
    RSB R9, R7, #0         // R9 = -NumIters
    STR R9, [R0, R5, LSL #2] // Store -NumIters at numbers[middleIndex]

    // Recalculate middleIndex = startIndex + (endIndex - startIndex) / 2
    SUB R9, R4, R3         // R9 = endIndex - startIndex
    MOV R9, R9, ASR #1     // R9 = (endIndex - startIndex) / 2
    ADD R5, R3, R9         // middleIndex = startIndex + R9

    ADD R7, R7, #1         // Increment NumIters
    B binary_search_loop   // Repeat loop

found_key:
    MOV R6, R5             // keyIndex = middleIndex

end_search:
    MOV R0, R6             // Return keyIndex in R0
    MOV PC, LR             // Return from function






