---
title: "08 — Data Structures"
topic: "C Programming"
tags: [c, data-structures, linked-list, stack, queue, tree, hash-table]
updated: 2026-06-14
---

# 08 — Data Structures

---

## Singly Linked List

```
head → [1|→] → [2|→] → [3|NULL]
```

```c
#include <stdlib.h>
#include <stdio.h>

typedef struct Node {
    int data;
    struct Node *next;
} Node;

// Create node
Node *node_new(int data) {
    Node *n = malloc(sizeof(Node));
    if (!n) return NULL;
    n->data = data;
    n->next = NULL;
    return n;
}

// Prepend (O(1))
Node *list_prepend(Node *head, int data) {
    Node *n = node_new(data);
    n->next = head;
    return n;
}

// Append (O(n))
Node *list_append(Node *head, int data) {
    Node *n = node_new(data);
    if (!head) return n;
    Node *cur = head;
    while (cur->next) cur = cur->next;
    cur->next = n;
    return head;
}

// Search (O(n))
Node *list_find(Node *head, int target) {
    while (head) {
        if (head->data == target) return head;
        head = head->next;
    }
    return NULL;
}

// Delete first occurrence
Node *list_delete(Node *head, int target) {
    Node *prev = NULL, *cur = head;
    while (cur) {
        if (cur->data == target) {
            if (prev) prev->next = cur->next;
            else head = cur->next;
            free(cur);
            return head;
        }
        prev = cur;
        cur = cur->next;
    }
    return head;
}

// Print
void list_print(const Node *head) {
    while (head) {
        printf("%d%s", head->data, head->next ? " → " : "\n");
        head = head->next;
    }
}

// Free entire list
void list_free(Node *head) {
    while (head) {
        Node *next = head->next;
        free(head);
        head = next;
    }
}
```

---

## Doubly Linked List

```
NULL ← [1|←→|2] ↔ [2|←→|3] ↔ [3|←→|NULL]
```

```c
typedef struct DNode {
    int data;
    struct DNode *prev;
    struct DNode *next;
} DNode;

DNode *dnode_new(int data) {
    DNode *n = malloc(sizeof(DNode));
    n->data = data;
    n->prev = n->next = NULL;
    return n;
}

// Insert after a given node
void dlist_insert_after(DNode *pos, DNode *new_node) {
    new_node->prev = pos;
    new_node->next = pos->next;
    if (pos->next) pos->next->prev = new_node;
    pos->next = new_node;
}

// Remove a node (O(1) given the node pointer)
DNode *dlist_remove(DNode *head, DNode *target) {
    if (target->prev) target->prev->next = target->next;
    else              head = target->next;
    if (target->next) target->next->prev = target->prev;
    free(target);
    return head;
}
```

---

## Stack (LIFO)

### Array-Based Stack

```c
#define STACK_CAP 256

typedef struct {
    int data[STACK_CAP];
    int top;
} Stack;

void  stack_init(Stack *s)          { s->top = -1; }
int   stack_empty(const Stack *s)   { return s->top < 0; }
int   stack_full(const Stack *s)    { return s->top == STACK_CAP - 1; }

int stack_push(Stack *s, int val) {
    if (stack_full(s)) return -1;
    s->data[++s->top] = val;
    return 0;
}

int stack_pop(Stack *s) {
    if (stack_empty(s)) return -1;   // or assert
    return s->data[s->top--];
}

int stack_peek(const Stack *s) {
    if (stack_empty(s)) return -1;
    return s->data[s->top];
}
```

**Use case:** expression evaluation, undo/redo, DFS traversal, function call tracking.

---

## Queue (FIFO)

### Circular Array Queue

```c
#define QUEUE_CAP 256

typedef struct {
    int  data[QUEUE_CAP];
    int  head;   // dequeue from here
    int  tail;   // enqueue here
    int  size;
} Queue;

void queue_init(Queue *q) { q->head = q->tail = q->size = 0; }
int  queue_empty(const Queue *q) { return q->size == 0; }
int  queue_full(const Queue *q)  { return q->size == QUEUE_CAP; }

int queue_enqueue(Queue *q, int val) {
    if (queue_full(q)) return -1;
    q->data[q->tail] = val;
    q->tail = (q->tail + 1) % QUEUE_CAP;
    q->size++;
    return 0;
}

int queue_dequeue(Queue *q) {
    if (queue_empty(q)) return -1;
    int val = q->data[q->head];
    q->head = (q->head + 1) % QUEUE_CAP;
    q->size--;
    return val;
}
```

**Use case:** BFS traversal, task scheduling, producer-consumer, I/O buffering.

---

## Binary Tree

```
        5
       / \
      3   8
     / \   \
    1   4   9
```

```c
typedef struct TNode {
    int data;
    struct TNode *left;
    struct TNode *right;
} TNode;

TNode *tnode_new(int data) {
    TNode *n = malloc(sizeof(TNode));
    n->data = data;
    n->left = n->right = NULL;
    return n;
}

// Traversals
void inorder(const TNode *root) {       // Left → Root → Right (sorted for BST)
    if (!root) return;
    inorder(root->left);
    printf("%d ", root->data);
    inorder(root->right);
}

void preorder(const TNode *root) {      // Root → Left → Right (copy tree, prefix expr)
    if (!root) return;
    printf("%d ", root->data);
    preorder(root->left);
    preorder(root->right);
}

void postorder(const TNode *root) {     // Left → Right → Root (delete tree, postfix)
    if (!root) return;
    postorder(root->left);
    postorder(root->right);
    printf("%d ", root->data);
}

// Height of tree
int tree_height(const TNode *root) {
    if (!root) return 0;
    int lh = tree_height(root->left);
    int rh = tree_height(root->right);
    return 1 + (lh > rh ? lh : rh);
}

// Free tree
void tree_free(TNode *root) {
    if (!root) return;
    tree_free(root->left);
    tree_free(root->right);
    free(root);
}
```

---

## Binary Search Tree (BST)

BST property: for every node, all values in its left subtree are smaller, and all values in its right subtree are larger.

```c
// Insert
TNode *bst_insert(TNode *root, int data) {
    if (!root) return tnode_new(data);
    if (data < root->data) root->left  = bst_insert(root->left,  data);
    else if (data > root->data) root->right = bst_insert(root->right, data);
    // duplicate: ignore (or handle as needed)
    return root;
}

// Search
TNode *bst_search(TNode *root, int target) {
    if (!root || root->data == target) return root;
    if (target < root->data) return bst_search(root->left,  target);
    return bst_search(root->right, target);
}

// Find minimum node (leftmost)
TNode *bst_min(TNode *root) {
    while (root && root->left) root = root->left;
    return root;
}

// Delete node
TNode *bst_delete(TNode *root, int target) {
    if (!root) return NULL;
    if (target < root->data) {
        root->left  = bst_delete(root->left,  target);
    } else if (target > root->data) {
        root->right = bst_delete(root->right, target);
    } else {
        // Node found
        if (!root->left) {          // 0 or 1 child (right)
            TNode *tmp = root->right;
            free(root);
            return tmp;
        } else if (!root->right) {  // 1 child (left)
            TNode *tmp = root->left;
            free(root);
            return tmp;
        }
        // 2 children: replace with inorder successor (smallest in right subtree)
        TNode *succ = bst_min(root->right);
        root->data  = succ->data;
        root->right = bst_delete(root->right, succ->data);
    }
    return root;
}
```

---

## Hash Table (Separate Chaining)

```c
#define HT_SIZE 64

typedef struct HEntry {
    char        *key;
    int          value;
    struct HEntry *next;
} HEntry;

typedef struct {
    HEntry *buckets[HT_SIZE];
} HashTable;

// djb2 hash function
unsigned long hash_str(const char *s) {
    unsigned long h = 5381;
    int c;
    while ((c = (unsigned char)*s++))
        h = ((h << 5) + h) + c;   // h * 33 + c
    return h % HT_SIZE;
}

void ht_set(HashTable *ht, const char *key, int value) {
    unsigned long idx = hash_str(key);
    HEntry *e = ht->buckets[idx];
    // Update existing
    while (e) {
        if (strcmp(e->key, key) == 0) { e->value = value; return; }
        e = e->next;
    }
    // Insert new
    HEntry *new = malloc(sizeof(HEntry));
    new->key   = strdup(key);
    new->value = value;
    new->next  = ht->buckets[idx];
    ht->buckets[idx] = new;
}

int ht_get(const HashTable *ht, const char *key, int *out) {
    unsigned long idx = hash_str(key);
    HEntry *e = ht->buckets[idx];
    while (e) {
        if (strcmp(e->key, key) == 0) { *out = e->value; return 1; }
        e = e->next;
    }
    return 0;  // not found
}

void ht_free(HashTable *ht) {
    for (int i = 0; i < HT_SIZE; i++) {
        HEntry *e = ht->buckets[i];
        while (e) {
            HEntry *next = e->next;
            free(e->key);
            free(e);
            e = next;
        }
        ht->buckets[i] = NULL;
    }
}
```

---

## Complexity Summary

| Structure | Access | Search | Insert | Delete | Space |
|-----------|--------|--------|--------|--------|-------|
| Array | O(1) | O(n) | O(n) | O(n) | O(n) |
| Linked List | O(n) | O(n) | O(1)* | O(1)* | O(n) |
| Stack (array) | O(n) | O(n) | O(1) | O(1) | O(n) |
| Queue (array) | O(n) | O(n) | O(1) | O(1) | O(n) |
| BST (balanced) | O(log n) | O(log n) | O(log n) | O(log n) | O(n) |
| Hash Table | — | O(1)† | O(1)† | O(1)† | O(n) |

\* O(1) given a pointer to the node; O(n) to find it first
† Average case; O(n) worst case (all keys collide)

---

## Practice Problems

<details>
<summary>Problem 1: Detect if a singly linked list has a cycle (Floyd's algorithm).</summary>

```c
int has_cycle(Node *head) {
    Node *slow = head, *fast = head;
    while (fast && fast->next) {
        slow = slow->next;
        fast = fast->next->next;
        if (slow == fast) return 1;  // cycle detected
    }
    return 0;
}
```
</details>

<details>
<summary>Problem 2: Reverse a singly linked list in-place.</summary>

```c
Node *list_reverse(Node *head) {
    Node *prev = NULL, *cur = head, *next;
    while (cur) {
        next = cur->next;
        cur->next = prev;
        prev = cur;
        cur  = next;
    }
    return prev;  // new head
}
```
</details>

<details>
<summary>Problem 3: Use a stack to check if parentheses in a string are balanced.</summary>

```c
int balanced(const char *s) {
    Stack st;
    stack_init(&st);
    for (; *s; s++) {
        if (*s == '(') stack_push(&st, '(');
        else if (*s == ')') {
            if (stack_empty(&st)) return 0;
            stack_pop(&st);
        }
    }
    return stack_empty(&st);
}
```
</details>
