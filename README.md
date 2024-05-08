### 3DKMI

This is the **MATLAB** package for extracting **3D Krawtchouk moment invariants**.

It can extract both local and global features from 3D images.

The features derived from the 3D images remain stable under translation, scaling, and rotation.

The program’s dependencies include the “Symbolic Math Toolbox” and the “Image Processing Toolbox”.

### A Simple Example

```
dim = 128;
path = 'please input the path that contains the slices/3D image file';
arr = readImage(path, dim);
invariants = get3DKMI(arr, dim);
```

A quick-start guide and more examples are available at https://krawtchouk.github.io/.