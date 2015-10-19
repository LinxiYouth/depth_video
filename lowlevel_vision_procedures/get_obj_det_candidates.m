function [masks, num_pxl_per_mask, candidates_db] = get_obj_det_candidates(img, obj_proposal_alg, vararg)
% returns a cell array of (sparse) masks, and a db for the candidates that
% is generated by the objects proposals algorithm

switch obj_proposal_alg
    case 'fayao_orig_superpix'
        candidates_db = vararg;
        N_cand = candidates_db.sp_num;
        masks = cell(N_cand,1);
        num_pxl_per_mask = nan(1, N_cand);
        msk = zeros(candidates_db.img_size);
        k = 1;
        for id = 1:N_cand
            msk(:) = false;
            msk(candidates_db.pixel_ind_sps{id}) = true;
            masks{id} = sparse(msk);
            k=k+1;
            num_pxl_per_mask(id) = nnz(masks{id});
        end
    case 'mcg_fast'
        candidates_db = im2mcg(img, 'fast');
        % evaluate each of the masks
        N_cand = size(candidates_db.scores,1);
        masks = cell(N_cand,1);
        num_pxl_per_mask = nan(1, N_cand);
        k = 1;
        for id = 1:N_cand
            masks{id} = get_mcg_mask_from_candidates(candidates_db, id);
            k=k+1;
            num_pxl_per_mask(id) = nnz(masks{id});
        end


    otherwise
        error ('unknown objects proposal algorithm (%s)', obj_proposal_alg);
end