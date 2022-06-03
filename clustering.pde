void genNeighbourhoods(ArrayList<Agent> agents, int n_clusters) {
  PVector[] centers = new PVector[n_clusters];
  int[] chosenPoints = new int[n_clusters];

  for (int i=0; i<chosenPoints.length; i++) {
    int randomIndex = int(random(agents.size()));
    chosenPoints[i] = randomIndex;
    for (int j=0; j<i; j++) {
      if (chosenPoints[i] == chosenPoints[j]) {
        i--;
      }
    }
  }

  for (int i=0; i<centers.length; i++) {
    centers[i] = agents.get(chosenPoints[i]).getPos();
  }

  while (true) {
    for (int i=0; i<agents.size(); i++) {
      agents.get(i).minDistanceToNeighbourhood = agents.get(i).getPos().dist(centers[0]);
      agents.get(i).neighbourhood = 0;
      for (int j=1; j<centers.length; j++) {
        float currDist = agents.get(i).getPos().dist(centers[j]);
        if (currDist < agents.get(i).minDistanceToNeighbourhood) {
          agents.get(i).minDistanceToNeighbourhood = currDist;
          agents.get(i).neighbourhood = j;
        }
      }
    }
    PVector[] newCenters = new PVector[n_clusters];
    for (int i=0; i<newCenters.length; i++) {
      newCenters[i] = new PVector(0.0, 0.0);
      int pointsPerCluster = 0;
      for (int j=0; j<agents.size(); j++) {
        if (agents.get(j).neighbourhood == i) {
          newCenters[i].add(agents.get(j).getPos());
          pointsPerCluster++;
        }
      }
      newCenters[i].div(max(pointsPerCluster, 1));
    }
    boolean noChange = true;
    for (int i=0; i<newCenters.length; i++) {
      if (newCenters[i].x != centers[i].x || newCenters[i].y != centers[i].y) {
        noChange = false;
        break;
      }
    }
    if (noChange) {
      break;
    }
    centers = newCenters;
  }
}
