import 'batch.dart';
import 'final_score.dart';

class InfoGraphicsData{
  int traineeCount;
  int trainerCount;
  int batchCount;
  List<FinalScore> finalScore;
  List<Batch> batches;

  InfoGraphicsData(
      this.traineeCount, this.trainerCount, this.batchCount, this.finalScore,this.batches);
}