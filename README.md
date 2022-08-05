# cvrp
i file contrassegnati con (*) sono eseguibili da MatLab, gli altri contengono funzioni o dati.

    TSPsolver.m
      solver esatto di un TSP
    check[...].m
      controlli su input di funzioni
    createActionList.m
      crea la lista di azioni per la tabu search
    cvrp[...]Main.m (*)
      file di setup, eseguibili in matlab
    doAction.m
      file di switch tra le varie azioni per la tabu search
    do[...].m
      implementazione dell'azione per la tabu search. 
      Eventualmente disponibili più versioni della stessa azione
    generateDistMatrix.m
      genera la matrice delle distanze euclidee
    greedy.m
      genera una soluzione di un problema CVRP adottando un'euristica
      greedy per assegnare un punto ad un veicolo basandosi esclusivamente
      sulla capacità
    kmeansCFRS.m
      implementa l'approccio cluster first route second, utilizzando
      kmeans per creare i cluster
    mainAllTests.m (*)
      esegue tutti i file di test forniti, crea e salva immagini e dati sulle soluzioni
    soluzioneCostruttivo[...].mat
      file di input per cvrpIterativoMain.m
    tabuSearch.m
      implementa tabu search come algoritmo iterativo
    test[...].mat
      file di input per cvrpCostruttivo.m
    tourLength.m
      calcola la funzione di costo
