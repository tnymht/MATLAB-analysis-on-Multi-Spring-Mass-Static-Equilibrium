# Case Study: MATLAB Analysis on Multi Spring–Mass Static Equilibrium

## Objective

Form the stiffness matrix for a 5 to 10 mass spring chain and compute displacement under applied loads using linear system solvers. Plot the displacement versus time graph for each mass.

---

# Comprehensive Description of Multi Spring–Mass System with Damping and Friction

## 1. System Description

The model represents a **1-D multi-degree-of-freedom spring–mass system**.

* There are **N masses** placed in a straight line.
* Each adjacent mass is connected by a **linear spring**.
* The first mass is connected to the left wall using a spring of stiffness ( k_0 ).
* The last mass is connected to the right wall using a spring of stiffness ( k_N ).
* An external force is applied to the first mass.
* The masses move horizontally.
* Friction exists between the masses and the floor.
* Viscous damping is present.

This system resembles vibration absorbers, suspension chains, and distributed mechanical systems.

---

## 2. Assumptions

1. Motion is only horizontal.
2. Springs are linear (Hooke’s Law).
3. Damping is viscous and proportional to velocity.
4. Friction is Coulomb friction proportional to ( \mu m g ).
5. Masses are treated as lumped point masses.
6. Gravity is constant.
7. No rotational effects.
8. Solution obtained using numerical time stepping.

---

## 3. Mathematical Model

### Governing Equation

```
M ẍ + C ẋ + K x + F_fric = F
```

Where:

* **M** — Mass matrix
* **C** — Damping matrix
* **K** — Stiffness matrix
* **x** — Displacement vector
* **ẋ** — Velocity vector
* **ẍ** — Acceleration vector
* **F_fric** — Friction force vector
* **F** — External force vector

---

### Mass Matrix (M)

```
M = diag(m1, m2, ..., mN)
```

Diagonal matrix representing inertia of each mass.

---

### Damping Matrix (C)

```
C = c I
```

Uniform viscous damping applied to all masses.

---

### Stiffness Matrix (K)

For internal masses:

```
K(i,i)   = k(i−1) + k(i)
K(i,i−1) = −k(i−1)
K(i,i+1) = −k(i)
```

Boundary conditions:

```
K(1,1)   = k0 + k1
K(N,N)   = k(N−1) + kN
```

---

### General Structure of Stiffness Matrix

```
| k0+k1   -k1       0        0      ... |
| -k1    k1+k2    -k2        0      ... |
|  0      -k2    k2+k3     -k3      ... |
|  .        .        .        .      ... |
|  0        0     -kN-1   kN-1+kN        |
```

**Characteristics:**

* Symmetric
* Sparse
* Tridiagonal
* Diagonally dominant
* Represents force equilibrium at each mass

---

## 4. Friction Model

```
F_fric = μ m g sign(v)
```

* Opposes motion
* Depends on velocity direction
* Acts independently on each mass
* Introduces nonlinearity

---

## 5. Time Integration (Explicit Euler Method)

Acceleration:

```
a = M⁻¹ (F − C v − K x − F_fric)
```

Velocity update:

```
v_new = v + dt a
```

Displacement update:

```
x_new = x + dt v
```

---

## 6. Loop and Conditional Logic

**For loops are used to:**

* Take user inputs
* Construct stiffness matrix
* Perform time stepping

**If conditions are used to:**

* Handle boundary cases in stiffness matrix
* Check steady state condition

Steady state is reached when:

```
max(|v|) < tolerance
max(|a|) < tolerance
```

---

## 7. Time Tracking

```
t(step+1) = t(step) + dt
```

Stores time incrementally and records displacement history to generate displacement vs time plots.

---

## 8. Engineering Interpretation

System response shows:

1. Initial acceleration due to applied force
2. Oscillatory behavior from springs
3. Energy dissipation from damping
4. Motion resistance from friction
5. Stabilization at static equilibrium

Final equilibrium condition:

```
K x_final = F − F_fric
```

---

## 9. Engineering Importance

Applications include:

* Multi-body vibration systems
* Structural dynamic chains
* Suspension modeling
* Conveyor assemblies
* Finite element discretized structures

---

## 10. Conclusion

This MATLAB implementation provides:

* Boundary and inter-mass springs
* Viscous damping
* Coulomb friction
* External force excitation
* Time domain numerical solution

The stiffness matrix follows a structured tridiagonal form.
The time-stepping loop simulates real dynamic evolution.
The stopping criterion ensures steady state detection.

This project demonstrates a complete numerical framework for analyzing interconnected mechanical systems under realistic damping and friction effects.
