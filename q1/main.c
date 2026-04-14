#include <stdio.h>
#include <stdlib.h>

struct Node {
    int val;
    struct Node* left;
    struct Node* right;
};

// assembly functions
struct Node* make_node(int val);
struct Node* insert(struct Node* root, int val);
struct Node* get(struct Node* root, int val);
int getAtMost(int val, struct Node* root);

int main() {
    struct Node* root = NULL;

    // -------- INSERT TEST --------
    root = insert(root, 5);
    printf("after insert 5\n");

    root = insert(root, 3);
    printf("after insert 3\n");

    root = insert(root, 7);
    printf("after insert 7\n");

    root = insert(root, 1);
    printf("after insert 1\n");

    // -------- GET TEST --------
    struct Node* n;

    n = get(root, 3);
    printf("get(3): %s\n", n ? "found" : "not found");

    n = get(root, 9);
    printf("get(9): %s\n", n ? "found" : "not found");

    // -------- getAtMost TEST --------
    printf("getAtMost(6): %d\n", getAtMost(6, root)); // expect 5
    printf("getAtMost(3): %d\n", getAtMost(3, root)); // expect 3
    printf("getAtMost(0): %d\n", getAtMost(0, root)); // expect -1

    return 0;
}