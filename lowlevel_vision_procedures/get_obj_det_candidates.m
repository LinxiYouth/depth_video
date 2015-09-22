function [masks, candidates_db] = get_obj_det_candidates(img, obj_proposal_alg)
% returns a cell array of (sparse) masks, and a db for the candidates that
% is generated by the objects proposals algorithm

switch obj_proposal_alg
    case 'mcg_fast'
        candidates_db = im2mcg(img, 'fast');
        % evaluate each of the masks
        N_cand = size(candidates_db.scores,1);
        masks = cell(N_cand,1);
        k = 1;
        for id = 1:N_cand
            masks{id} = get_mcg_mask_from_candidates(candidates_db, id);
            k=k+1;
        end

    otherwise
        error ('unknown objects proposal algorithm (%s)', obj_proposal_alg);
end