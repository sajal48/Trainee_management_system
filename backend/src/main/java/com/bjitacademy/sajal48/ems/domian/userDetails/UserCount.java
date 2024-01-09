package com.bjitacademy.sajal48.ems.domian.userDetails;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserCount {
    private long adminCount;
    private long trainerCount;
    private long traineeCount;
}
