for SC_AMOUNT in 3600 1800 0900 0450 0225
do
      python -m ptls.pl_fit_target \
            logger_name="fit_target_${SC_AMOUNT}" \
            trainer.max_epochs=20 \
            data_module.train.drop_last=true \
            data_module.train.labeled_amount=$SC_AMOUNT \
            embedding_validation_results.feature_name="target_scores_${SC_AMOUNT}" \
            embedding_validation_results.output_path="results/fit_target_${SC_AMOUNT}_results.json" \
            --config-dir conf --config-name pl_fit_target

      python -m ptls.pl_fit_target \
            logger_name="mles_finetuning_${SC_AMOUNT}" \
            trainer.max_epochs=10 \
            data_module.train.drop_last=true \
            data_module.train.labeled_amount=$SC_AMOUNT \
            embedding_validation_results.feature_name="mles_finetuning_${SC_AMOUNT}" \
            embedding_validation_results.output_path="results/mles_finetuning_${SC_AMOUNT}_results.json" \
            --config-dir conf --config-name pl_fit_finetuning_mles

      python -m ptls.pl_fit_target \
            logger_name="cpc_finetuning_${SC_AMOUNT}" \
            trainer.max_epochs=10 \
            data_module.train.drop_last=true \
            data_module.train.labeled_amount=$SC_AMOUNT \
            embedding_validation_results.feature_name="cpc_finetuning_${SC_AMOUNT}" \
            embedding_validation_results.output_path="results/cpc_finetuning_${SC_AMOUNT}_results.json" \
            --config-dir conf --config-name pl_fit_finetuning_cpc
done

rm results/scenario_rosbank__semi_supervised.txt
python -m embeddings_validation \
  --config-dir conf --config-name embeddings_validation_semi_supervised \
  --workers 10 --total_cpu_count 18
