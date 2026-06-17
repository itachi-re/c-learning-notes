---
title: "09 — Algorithms"
topic: "C Programming"
tags: [c, algorithms, sorting, searching, complexity, big-o]
updated: 2026-06-14
---

# 09 — Algorithms

---

## Complexity Analysis

### Big O — Upper Bound (Worst Case)

| Notation | Name | Example |
|----------|------|---------|
| O(1) | Constant | Array access, hash table lookup |
| O(log n) | Logarithmic | Binary search, BST operations |
| O(n) | Linear | Linear search, single array pass |
| O(n log n) | Linearithmic | Merge sort, heap sort |
| O(n²) | Quadratic | Bubble sort, insertion sort (worst) |
| O(2ⁿ) | Exponential | Naive Fibonacci, brute-force |

**Asymptotic growth:**
```
O(1) < O(log n) < O(n) < O(n log n) < O(n²) < O(2ⁿ) < O(n!)
```

### Rules
- **Drop constants:** O(3n) → O(n)
- **Drop non-dominant terms:** O(n² + n) → O(n²)
- **Worst case** is usually what matters most

---

## Sorting Algorithms

### Helper: Swap

```c
static inline void swap(int *a, int *b) {
    int tmp = *a; *a = *b; *b = tmp;
}
```

---

### Bubble Sort — O(n²)

Repeatedly swap adjacent elements until the array is sorted.

```c
void bubble_sort(int *arr, int n) {
    for (int i = 0; i < n - 1; i++) {
        int swapped = 0;
        for (int j = 0; j < n - 1 - i; j++) {
            if (arr[j] > arr[j + 1]) {
                swap(&arr[j], &arr[j + 1]);
                swapped = 1;
            }
        }
        if (!swapped) break;   // early exit: already sorted
    }
}
```

| | Best | Average | Worst | Space |
|-|------|---------|-------|-------|
| Bubble | O(n) | O(n²) | O(n²) | O(1) |

✅ Simple, in-place, stable
❌ Very slow for large inputs

---

### Selection Sort — O(n²)

Find the minimum of the unsorted portion and place it at the front.

```c
void selection_sort(int *arr, int n) {
    for (int i = 0; i < n - 1; i++) {
        int min_idx = i;
        for (int j = i + 1; j < n; j++) {
            if (arr[j] < arr[min_idx]) min_idx = j;
        }
        if (min_idx != i) swap(&arr[i], &arr[min_idx]);
    }
}
```

| | Best | Average | Worst | Space |
|-|------|---------|-------|-------|
| Selection | O(n²) | O(n²) | O(n²) | O(1) |

✅ Minimal writes (O(n) swaps)
❌ Not adaptive, not stable

---

### Insertion Sort — O(n²) worst, O(n) best

Build the sorted portion one element at a time by shifting.

```c
void insertion_sort(int *arr, int n) {
    for (int i = 1; i < n; i++) {
        int key = arr[i];
        int j = i - 1;
        while (j >= 0 && arr[j] > key) {
            arr[j + 1] = arr[j];
            j--;
        }
        arr[j + 1] = key;
    }
}
```

| | Best | Average | Worst | Space |
|-|------|---------|-------|-------|
| Insertion | O(n) | O(n²) | O(n²) | O(1) |

✅ Best for small or nearly-sorted arrays, stable, in-place, adaptive
❌ Slow for large random inputs

---

### Merge Sort — O(n log n)

Divide-and-conquer: split array in half, recursively sort, merge.

```c
static void merge(int *arr, int lo, int mid, int hi) {
    int n1 = mid - lo + 1, n2 = hi - mid;
    int *L = malloc(n1 * sizeof(int));
    int *R = malloc(n2 * sizeof(int));

    for (int i = 0; i < n1; i++) L[i] = arr[lo + i];
    for (int j = 0; j < n2; j++) R[j] = arr[mid + 1 + j];

    int i = 0, j = 0, k = lo;
    while (i < n1 && j < n2)
        arr[k++] = (L[i] <= R[j]) ? L[i++] : R[j++];
    while (i < n1) arr[k++] = L[i++];
    while (j < n2) arr[k++] = R[j++];

    free(L); free(R);
}

void merge_sort(int *arr, int lo, int hi) {
    if (lo >= hi) return;
    int mid = lo + (hi - lo) / 2;   // avoids overflow vs (lo+hi)/2
    merge_sort(arr, lo, mid);
    merge_sort(arr, mid + 1, hi);
    merge(arr, lo, mid, hi);
}

// Call: merge_sort(arr, 0, n - 1);
```

| | Best | Average | Worst | Space |
|-|------|---------|-------|-------|
| Merge | O(n log n) | O(n log n) | O(n log n) | O(n) |

✅ Stable, guaranteed O(n log n), great for linked lists
❌ O(n) extra space

---

### Quick Sort — O(n log n) average

Pick a pivot, partition array around it, recurse on both halves.

```c
static int partition(int *arr, int lo, int hi) {
    int pivot = arr[hi];    // last element as pivot
    int i = lo - 1;
    for (int j = lo; j < hi; j++) {
        if (arr[j] <= pivot) {
            i++;
            swap(&arr[i], &arr[j]);
        }
    }
    swap(&arr[i + 1], &arr[hi]);
    return i + 1;
}

void quick_sort(int *arr, int lo, int hi) {
    if (lo >= hi) return;
    int pi = partition(arr, lo, hi);
    quick_sort(arr, lo, pi - 1);
    quick_sort(arr, pi + 1, hi);
}

// Call: quick_sort(arr, 0, n - 1);
```

| | Best | Average | Worst | Space |
|-|------|---------|-------|-------|
| Quick | O(n log n) | O(n log n) | O(n²) | O(log n) stack |

✅ In-place, cache-friendly, fast in practice (small constant)
❌ O(n²) on already-sorted input with bad pivot; not stable

**Mitigation:** Randomize pivot or use median-of-three.

---

### Standard Library `qsort`

```c
#include <stdlib.h>

// Comparator: returns negative, zero, or positive
int cmp_int(const void *a, const void *b) {
    int ia = *(const int *)a;
    int ib = *(const int *)b;
    return (ia > ib) - (ia < ib);   // branchless
    // Avoid: return ia - ib;  (integer overflow risk)
}

int arr[] = {5, 2, 8, 1, 9};
qsort(arr, 5, sizeof(int), cmp_int);

// Sort structs by a field
typedef struct { char name[32]; int score; } Student;

int cmp_by_score(const void *a, const void *b) {
    const Student *sa = a, *sb = b;
    return (sa->score > sb->score) - (sa->score < sb->score);
}
```

---

## Searching Algorithms

### Linear Search — O(n)

```c
int linear_search(const int *arr, int n, int target) {
    for (int i = 0; i < n; i++) {
        if (arr[i] == target) return i;
    }
    return -1;
}
```

Works on unsorted arrays.

---

### Binary Search — O(log n)

Requires a **sorted** array.

```c
int binary_search(const int *arr, int n, int target) {
    int lo = 0, hi = n - 1;
    while (lo <= hi) {
        int mid = lo + (hi - lo) / 2;   // safe midpoint
        if (arr[mid] == target) return mid;
        if (arr[mid]  < target) lo = mid + 1;
        else                    hi = mid - 1;
    }
    return -1;
}
```

Standard library: `bsearch` (same comparator signature as `qsort`).

```c
int *found = bsearch(&target, arr, n, sizeof(int), cmp_int);
```

---

## Sorting Algorithm Comparison

| Algorithm | Best | Average | Worst | Space | Stable | Notes |
|-----------|------|---------|-------|-------|--------|-------|
| Bubble | O(n) | O(n²) | O(n²) | O(1) | ✅ | Educational |
| Selection | O(n²) | O(n²) | O(n²) | O(1) | ❌ | Min writes |
| Insertion | O(n) | O(n²) | O(n²) | O(1) | ✅ | Best < 20 elements |
| Merge | O(n log n) | O(n log n) | O(n log n) | O(n) | ✅ | Linked lists, external sort |
| Quick | O(n log n) | O(n log n) | O(n²) | O(log n) | ❌ | Fastest in practice |
| `qsort` | — | O(n log n) | O(n log n) | — | impl. | Use this in real code |

**Practical rule:**
- n < 20 → Insertion sort
- n < 1000 → Quick sort
- Need stability → Merge sort
- Default → `qsort` from `<stdlib.h>`

---

## Practice Problems

<details>
<summary>Problem 1: Implement `bsearch` returning the insertion point (lower_bound) when target not found.</summary>

```c
// Returns index where target would be inserted to keep array sorted
int lower_bound(const int *arr, int n, int target) {
    int lo = 0, hi = n;
    while (lo < hi) {
        int mid = lo + (hi - lo) / 2;
        if (arr[mid] < target) lo = mid + 1;
        else                   hi = mid;
    }
    return lo;
}
```
</details>

<details>
<summary>Problem 2: Sort an array of strings with `qsort`.</summary>

```c
int cmp_str(const void *a, const void *b) {
    return strcmp(*(const char **)a, *(const char **)b);
}

const char *words[] = {"banana", "apple", "cherry", "date"};
qsort(words, 4, sizeof(char *), cmp_str);
// result: apple banana cherry date
```
</details>

<details>
<summary>Problem 3: What is the worst case for quick sort and how can you avoid it?</summary>

Worst case O(n²) occurs when the pivot is always the minimum or maximum element — e.g., already-sorted input with a fixed first/last pivot.

**Mitigations:**
1. **Random pivot:** `int ri = lo + rand() % (hi - lo + 1); swap(&arr[ri], &arr[hi]);` before partitioning.
2. **Median-of-three:** choose the median of `arr[lo]`, `arr[mid]`, `arr[hi]` as pivot.
3. **Introsort:** (used by most standard library implementations) starts with quicksort, falls back to heapsort when recursion depth exceeds O(log n) — guarantees O(n log n) worst case.
</details>
