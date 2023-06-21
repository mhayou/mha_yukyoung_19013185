function E = solveKepler(MO, e)
    % Solve Kepler's equation using Newton-Raphson iteration

    % Initial guess for eccentric anomaly (E)
    E = MO;

    % Convergence tolerance
    tol = 1e-8;

    % Iterative calculation of E
    while true
        E_next = E - (E - e*sin(E) - MO) / (1 - e*cos(E));
        if abs(E_next - E) < tol
            break;
        end
        E = E_next;
    end
end
